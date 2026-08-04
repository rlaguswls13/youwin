package com.youwin.service;

import com.youwin.dto.NoticeDto;
import com.youwin.repository.NoticeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class NoticeService {

    private final NoticeRepository noticeRepository;
    private final NoticeImageService noticeImageService;

    @Autowired
    public NoticeService(NoticeRepository noticeRepository, NoticeImageService noticeImageService) {
        this.noticeRepository = noticeRepository;
        this.noticeImageService = noticeImageService;
    }

    // 1. 공지사항 작성 (등록)
    @Transactional
    public void writeNotice(NoticeDto notice) {
        noticeRepository.save(notice);

        if (notice.getNoticeId() != null && notice.getFiles() != null) {
            noticeImageService.saveImages(notice.getNoticeId(), java.util.Arrays.asList(notice.getFiles()));
        }
    }

    // 2. 공지사항 페이지네이션 및 검색 구역
    @Transactional(readOnly = true)
    public List<NoticeDto> getNotices() {
        return noticeRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<NoticeDto> getNoticesWithPaging(Map<String, Object> params) {
        return noticeRepository.findAllWithPaging(params);
    }

    @Transactional(readOnly = true)
    public int getTotalCount(Map<String, Object> params) {
        return noticeRepository.countTotal(params);
    }

    // 3. 공지사항 삭제
    @Transactional
    public void deleteNotice(Long noticeId) {
        noticeImageService.deleteImagesByNoticeId(noticeId);
        noticeRepository.deleteById(noticeId);
    }

    // 4. 공지사항 수정 구역 (이미지 동기화 처리 연동)
    @Transactional
    public void modifyNotice(NoticeDto notice, List<String> existingFiles) {
        noticeRepository.update(notice);

        if (notice.getNoticeId() != null) {
            noticeImageService.updateBoardImages(notice.getNoticeId(), notice.getFiles(), existingFiles);
        }
    }

    // 5. 공지사항 단건 상세 조회 구역
    @Transactional(readOnly = true)
    public NoticeDto getNoticeById(Long noticeId) {
        return noticeRepository.findById(noticeId);
    }
}