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
import org.springframework.web.bind.annotation.PathVariable;

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

    // [추가] 공지사항 단건 상세 조회 (더블클릭 화면 연동)
    @GetMapping("/board/{noticeId}")
    public String detailNotice(@PathVariable("noticeId") Long noticeId, Model model) {
        // 서비스단에서 글 번호로 해당 공지사항 상세 데이터 한 건을 가져옵니다.
        NoticeDto notice = boardService.getNoticeById(noticeId);

        // 가져온 데이터를 폼 영역이나 화면에 렌더링할 수 있도록 모델에 담아 보냅니다.
        model.addAttribute("notice", notice);

        // 단건 상세보기를 처리할 뷰 이름이나 혹은 기존 board 뷰 내에서 탭 제어를 유도합니다.
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

    // 3. [추가] 공지사항 삭제 처리 메서드
    @PostMapping("/board/delete")
    public String deleteNotice(@RequestParam("noticeId") Long noticeId) {
        // 서비스단에 글 번호(noticeId)를 전달하여 삭제 로직 수행
        boardService.deleteNotice(noticeId);

        // 삭제 처리가 완료되면 다시 목록(/board)으로 돌아갑니다.
        return "redirect:/board";
    }

    // [추가] 공지사항 수정 처리 메서드
    @PostMapping("/board/modify")
    public String modifyNotice(
            @RequestParam("noticeId") Long noticeId,
            @RequestParam("category") String category,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "isPinned", required = false) String isPinned) {

        NoticeDto noticeDto = new NoticeDto();
        noticeDto.setNoticeId(noticeId);
        noticeDto.setCategory(category);
        noticeDto.setTitle(title);
        noticeDto.setContent(content);
        noticeDto.setIsPinned(isPinned == null ? 0 : 1);

        // 서비스단의 수정 기능 호출
        boardService.modifyNotice(noticeDto);
        return "redirect:/board";
    }
}