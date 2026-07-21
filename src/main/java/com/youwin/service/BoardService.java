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
}
