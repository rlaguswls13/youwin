package com.youwin.service;

import com.youwin.dto.NoticeDto;
import com.youwin.repository.NoticeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BoardService {

    private final NoticeRepository noticeRepository;

    public BoardService(NoticeRepository noticeRepository) {
        this.noticeRepository = noticeRepository;
    }

    @Transactional(readOnly = true)
    public List<NoticeDto> getNotices() {
        return noticeRepository.findAll();
    }

    @Transactional
    public void writeNotice(NoticeDto notice) {
        noticeRepository.save(notice);
    }

    // 💡 3. [추가] 컨트롤러에서 호출할 공지사항 삭제 로직
    @Transactional
    public void deleteNotice(Long noticeId) {
        // 위에서 선언한 레포지토리의 deleteById 메서드를 실행합니다.
        noticeRepository.deleteById(noticeId);
    }
}