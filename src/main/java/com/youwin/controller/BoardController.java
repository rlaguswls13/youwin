package com.youwin.controller;

import com.youwin.dto.NoticeDto;
import com.youwin.service.BoardService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class BoardController {

    private final BoardService boardService;

    @Autowired
    public BoardController(BoardService boardService) {
        this.boardService = boardService;
    }

    // 1. 공지사항 목록 조회 (기존 유지)
    @GetMapping("/board")
    public String boardPage(Model model) {
        List<NoticeDto> noticeList = boardService.getNotices();
        model.addAttribute("list", noticeList);
        return "board";
    }

    // 2. 공지사항 작성 처리 (기존 유지)
    @PostMapping("/board/write")
    public String writeNotice(
            @RequestParam("category") String category,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "isPinned", required = false) String isPinned) {

        NoticeDto noticeDto = new NoticeDto();

        noticeDto.setMemberId(null);
        noticeDto.setCategory(category);
        noticeDto.setTitle(title);
        noticeDto.setContent(content);

        if (isPinned == null) {
            noticeDto.setIsPinned(0);
        } else {
            noticeDto.setIsPinned(1);
        }

        boardService.writeNotice(noticeDto);

        return "redirect:/board";
    }

    // 💡 3. [추가] 공지사항 삭제 처리 메서드
    @PostMapping("/board/delete")
    public String deleteNotice(@RequestParam("noticeId") Long noticeId) {
        // 서비스단에 글 번호(noticeId)를 전달하여 삭제 로직 수행
        boardService.deleteNotice(noticeId);

        // 삭제 처리가 완료되면 다시 목록(/board)으로 돌아갑니다.
        return "redirect:/board";
    }
}