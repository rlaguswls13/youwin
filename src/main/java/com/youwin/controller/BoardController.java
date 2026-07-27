package com.youwin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.youwin.dto.NoticeDto;
import com.youwin.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardService boardService;

    @Autowired
    public BoardController(BoardService boardService) {
        this.boardService = boardService;
    }

    @GetMapping("/")
    public String list() {
        return "board";
    }

    // ==========================================
    // 1. 공지사항 작성 (등록) 구역
    // ==========================================
    @PostMapping("/write")
    public String writeNotice(
            @ModelAttribute NoticeDto noticeDto,
            @RequestParam(value = "isPinned", required = false) String isPinned) {

        noticeDto.setIsPinned(isPinned == null ? 0 : 1);

        boardService.writeNotice(noticeDto);

        return "redirect:/board";
    }

    // ==========================================
    // 2. 공지사항 페이지네이션 및 검색 구역
    // ==========================================
    @GetMapping("")
    public String boardPage(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "category", defaultValue = "all") String category,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            Model model) {

        int limit = 10;

        // [1단계] 검색 데이터 맵 구성
        Map<String, Object> searchParams = createSearchParamMap(page, limit, category, keyword);

        // [2단계] 조건에 맞는 데이터 리스트 검색
        List<NoticeDto> noticeList = boardService.getNoticesWithPaging(searchParams);

        // [3단계] 검색된 총 데이터 개수 조회
        int totalCount = boardService.getTotalCount(searchParams);

        // [4단계] 하단 페이지네이션(화살표, 번호) 수학 연산 실행
        Map<String, Object> pageMaker = executePaginationMapping(page, limit, totalCount, category, keyword);

        // [5단계] 검색 및 페이징 최종 결과 바인딩 (JSP 데이터 전송)
        model.addAttribute("list", noticeList);
        model.addAttribute("pageMaker", pageMaker);

        return "board";
    }

    /**
     * [페이지네이션 연산 메서드] 하단 페이징 화면 제어용 수학 연산 전담
     */
    private Map<String, Object> executePaginationMapping(int page, int limit, int totalCount, String category, String keyword) {
        int endPage = (int) (Math.ceil(page / 10.0) * 10);
        int startPage = (endPage - 9);
        int realEnd = (int) (Math.ceil((totalCount * 1.0) / limit));

        if (realEnd < endPage) endPage = realEnd;
        if (endPage == 0) endPage = 1;

        Map<String, Object> pageMaker = new HashMap<>();
        Map<String, Object> cri = new HashMap<>();

        cri.put("page", page);
        cri.put("category", category);
        cri.put("keyword", keyword);

        pageMaker.put("cri", cri);
        pageMaker.put("startPage", startPage);
        pageMaker.put("endPage", endPage);
        pageMaker.put("prev", startPage > 1);
        pageMaker.put("next", endPage < realEnd);

        return pageMaker;
    }

    /**
     * [검색 파라미터 메서드] 검색 조건 설정 및 DB 조회용 파라미터 맵 구성 전담
     */
    private Map<String, Object> createSearchParamMap(int page, int limit, String category, String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", (page - 1) * limit);
        params.put("limit", limit);
        params.put("category", category);
        params.put("keyword", keyword.trim());
        return params;
    }

    // ==========================================
    // 3. 공지사항 삭제 구역
    // ==========================================
    @PostMapping("/delete")
    public String deleteNotice(@RequestParam("noticeId") Long noticeId) {
        boardService.deleteNotice(noticeId);
        return "redirect:/board";
    }

    // ==========================================
    // 4. 공지사항 수정 구역
    // ==========================================
    @PostMapping("/modify")
    public String modifyNotice(
            @ModelAttribute NoticeDto noticeDto,
            @RequestParam(value = "isPinned", required = false) String isPinned) {

        noticeDto.setIsPinned(isPinned == null ? 0 : 1);

        boardService.modifyNotice(noticeDto);
        return "redirect:/board";
    }

    // ==========================================
    // 5
    // . 공지사항 단건 상세 조회 구역
    // ==========================================
    @GetMapping("/{noticeId}")
    public String detailNotice(@PathVariable("noticeId") Long noticeId, Model model) {
        NoticeDto notice = boardService.getNoticeById(noticeId);
        model.addAttribute("notice", notice);
        return "board";
    }
}