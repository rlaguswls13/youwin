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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class BoardController {

    private final BoardService boardService;

    @Autowired
    public BoardController(BoardService boardService) {
        this.boardService = boardService;
    }

    // 1. 공지사항 목록 조회 (페이징, 카테고리 필터, 키워드 검색 연동 수정)
    @GetMapping("/board")
    public String boardPage(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "category", defaultValue = "all") String category,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            Model model) {

        // [수정] 한 화면에 보여줄 작성글 개수 고정 세팅
        int limit = 10;
        int offset = (page - 1) * limit;

        // [수정] MyBatis 쿼리에 전달할 파라미터 맵 구성
        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", limit);
        params.put("category", category);
        params.put("keyword", keyword.trim());

        // [수정] 페이징 조건에 맞는 글 목록 및 검색 결과 총 개수 조회
        List<NoticeDto> noticeList = boardService.getNoticesWithPaging(params);
        int totalCount = boardService.getTotalCount(params);

        // [추가] JSP에 동적 렌더링 데이터를 넘겨주기 위한 pageMaker 객체 생성 및 수학적 연산 수행
        Map<String, Object> pageMaker = new HashMap<>();
        Map<String, Object> cri = new HashMap<>();
        cri.put("page", page);
        cri.put("category", category);
        cri.put("keyword", keyword);
        pageMaker.put("cri", cri);

        // 하단 페이지네이션 블록 연산 (10번까지 보이고 좌우 화살표로 이동하는 산식)
        int endPage = (int) (Math.ceil(page / 10.0) * 10);
        int startPage = (endPage - 9);
        int realEnd = (int) (Math.ceil((totalCount * 1.0) / limit));

        if (realEnd < endPage) {
            endPage = realEnd;
        }
        if (endPage == 0) {
            endPage = 1;
        }

        pageMaker.put("startPage", startPage);
        pageMaker.put("endPage", endPage);
        pageMaker.put("prev", startPage > 1);
        pageMaker.put("next", endPage < realEnd);

        // 모델 바인딩 후 JSP 뷰 리턴
        model.addAttribute("list", noticeList);
        model.addAttribute("pageMaker", pageMaker);

        return "board";
    }

    // 공지사항 단건 상세 조회 (더블클릭 화면 연동 - 기존 유지)
    @GetMapping("/board/{noticeId}")
    public String detailNotice(@PathVariable("noticeId") Long noticeId, Model model) {
        NoticeDto notice = boardService.getNoticeById(noticeId);
        model.addAttribute("notice", notice);
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

    // 3. 공지사항 삭제 처리 메서드 (기존 유지)
    @PostMapping("/board/delete")
    public String deleteNotice(@RequestParam("noticeId") Long noticeId) {
        boardService.deleteNotice(noticeId);
        return "redirect:/board";
    }

    // 공지사항 수정 처리 메서드 (기존 유지)
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

        boardService.modifyNotice(noticeDto);
        return "redirect:/board";
    }
}