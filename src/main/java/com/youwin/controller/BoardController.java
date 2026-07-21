package com.youwin.controller;

import com.youwin.dto.NoticeDto;
import com.youwin.service.BoardService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class BoardController {

    private final BoardService boardService;

    public BoardController(BoardService boardService) {
        this.boardService = boardService;
    }

    // 1. 공지사항 목록 조회
    @GetMapping("/board")
    public String boardPage(Model model) {
        List<NoticeDto> noticeList = boardService.getNotices();
        model.addAttribute("list", noticeList);
        return "board";
    }

    // 2. 공지사항 작성 처리 (외래키 누락 완벽 방어 버전)
    @PostMapping("/board/write")
    public String writeNotice(
            @RequestParam("category") String category,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "isPinned", required = false) String isPinned) {

        NoticeDto noticeDto = new NoticeDto();

        // 💡 [변경] 부모 테이블과의 충돌을 방지하기 위해 memberId를 세팅하지 않고(null) 진행합니다.
        // DB 설계 시 member_id NULL을 허용해 두셨기 때문에 아무 문제 없이 저장됩니다.
        noticeDto.setMemberId(null);

        noticeDto.setCategory(category);
        noticeDto.setTitle(title);
        noticeDto.setContent(content);

        // 체크박스 처리
        if (isPinned == null) {
            noticeDto.setIsPinned(0);
        } else {
            noticeDto.setIsPinned(1);
        }

        // DB 저장 수행
        boardService.writeNotice(noticeDto);

        // 완료 후 리스트로 리다이렉트
        return "redirect:/board";
    }
}
