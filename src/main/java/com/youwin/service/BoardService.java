package com.youwin.service;

import com.youwin.dto.NoticeDto;
import com.youwin.repository.NoticeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class BoardService {

    private final NoticeRepository noticeRepository;

    public BoardService(NoticeRepository noticeRepository) {
        this.noticeRepository = noticeRepository;
    }

    // 1. 공지사항 작성 (등록) 구역
    // 기존 작성 로직
    @Transactional
    public void writeNotice(NoticeDto notice) {
        noticeRepository.save(notice);
    }

    // 2. 공지사항 페이지네이션 및 검색 구역
    // 기존 전체 조회 메서드 (다른 비즈니스 로직에 영향이 없도록 그대로 보존)
    @Transactional(readOnly = true)
    public List<NoticeDto> getNotices() {
        return noticeRepository.findAll();
    }

    // 컨트롤러의 페이징 및 검색 요청 처리를 위한 읽기 전용 서비스 메서드
    @Transactional(readOnly = true)
    public List<NoticeDto> getNoticesWithPaging(Map<String, Object> params) {
        return noticeRepository.findAllWithPaging(params);
    }

    // 컨트롤러의 페이지네이션 연산을 위해 검색 조건이 포함된 게시글 총 개수를 반환하는 메서드
    @Transactional(readOnly = true)
    public int getTotalCount(Map<String, Object> params) {
        return noticeRepository.countTotal(params);
    }

    // 3. 공지사항 삭제 구역
    // 공지사항 삭제 로직
    @Transactional
    public void deleteNotice(Long noticeId) {
        noticeRepository.deleteById(noticeId);
    }

    // 4. 공지사항 수정 구역
    // 공지사항 데이터를 변경하는 비즈니스 서비스 로직
    @Transactional
    public void modifyNotice(NoticeDto notice) {
        noticeRepository.update(notice);
    }

    // 5. 공지사항 단건 상세 조회 구역
    // 공지사항 단건 상세 조회 로직 (더블클릭 조회 연동)
    @Transactional(readOnly = true)
    public NoticeDto getNoticeById(Long noticeId) {
        return noticeRepository.findById(noticeId);
    }
}