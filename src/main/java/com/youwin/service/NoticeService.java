package com.youwin.service;

import com.youwin.dto.BoardListResult;
import com.youwin.dto.BoardSearchCondition;
import com.youwin.dto.NoticeDto;
import com.youwin.dto.PageInfo;
import com.youwin.repository.NoticeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Service
@RequiredArgsConstructor // @Autowired 생략 및 final 필드 의존성 자동 주입
@Transactional
public class NoticeService {

    private final NoticeRepository noticeRepository;
    private final NoticeImageService noticeImageService; // 👈 이미지 처리는 전담 서비스에 위임

    // 1. 공지사항 등록 (글 저장 + 이미지 전담 서비스 호출)
    public Long writeNotice(NoticeDto noticeDto, List<MultipartFile> images) throws IOException {
        noticeRepository.save(noticeDto); // 실행 후 noticeDto의 noticeId는 자동 채워짐

        if (noticeDto.getNoticeId() != null && images != null && !images.isEmpty()) {
            noticeImageService.saveImages(noticeDto.getNoticeId(), images);
        }

        return noticeDto.getNoticeId();
    }

    // 2. 페이징 및 검색 조건이 포함된 목록 조회 결과 반환
    @Transactional(readOnly = true)
    public BoardListResult getNoticeList(BoardSearchCondition condition) {
        int totalCount = noticeRepository.countTotal(condition);

        PageInfo pageInfo = new PageInfo(condition.getPage(), condition.getSize(), totalCount);
        condition.setOffset(pageInfo.getOffset());
        condition.setLimit(pageInfo.getSize());

        List<NoticeDto> noticeList = noticeRepository.findAllWithPaging(condition);

        return new BoardListResult(noticeList, pageInfo, condition);
    }

    // 3. 단건 상세 조회 (첨부 이미지 목록 포함)
    @Transactional(readOnly = true)
    public NoticeDto getNoticeById(Long noticeId) {
        NoticeDto notice = noticeRepository.findById(noticeId);

        if (notice == null) {
            throw new IllegalStateException("존재하지 않는 공지사항입니다.");
        }

        // 이미지 전담 서비스를 통해 해당 글의 이미지 목록 조회 후 세팅
        notice.setImageList(noticeImageService.getImagesByNoticeId(noticeId));

        return notice;
    }

    // 4. 공지사항 수정 (게시글 수정 + 이미지 동기화 처리 위임)
    public void modifyNotice(Long noticeId, NoticeDto noticeDto, List<MultipartFile> newImages, List<String> existingFiles) throws IOException {
        NoticeDto original = noticeRepository.findById(noticeId);
        if (original == null) {
            throw new IllegalArgumentException("존재하지 않는 공지사항입니다.");
        }

        noticeDto.setNoticeId(noticeId);
        noticeRepository.update(noticeDto);

        // 이미지 동기화 및 수정 처리는 NoticeImageService에 일임
        noticeImageService.updateBoardImages(noticeId, newImages, existingFiles);
    }

    // 5. 공지사항 삭제 (이미지 파일 및 데이터 일괄 정리 위임)
    public void deleteNotice(Long noticeId) {
        noticeImageService.deleteImagesByNoticeId(noticeId);
        noticeRepository.deleteById(noticeId);
    }
}