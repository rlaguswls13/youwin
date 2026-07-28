package com.youwin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.youwin.dto.NoticeDto;
import com.youwin.dto.NoticeImageDto;
import com.youwin.service.BoardService;
import com.youwin.service.NoticeImageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardService boardService;
    // 이미지 조회를 위해 방금 완성한 이미지 서비스 주입용 멤버 변수
    private final NoticeImageService noticeImageService;

    // 생성자에 NoticeImageService를 추가하여 스프링이 자동으로 주입하도록 연동
    @Autowired
    public BoardController(BoardService boardService, NoticeImageService noticeImageService) {
        this.boardService = boardService;
        this.noticeImageService = noticeImageService;
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
            @RequestParam(value = "isPinned", required = false) String isPinned,
            @RequestParam(value = "files", required = false) MultipartFile[] files) { // 등록 시 첨부 파일 수신

        noticeDto.setIsPinned(isPinned == null ? 0 : 1);

        // 1. 글 등록 처리 (이 과정에서 MyBatis 등을 통해 noticeDto에 noticeId가 채워져야 합니다)
        boardService.writeNotice(noticeDto);

        // 2. [수정 완료] 등록된 글 ID와 함께 이미지 파일 저장 서비스 호출
        if (files != null && files.length > 0) {
            List<MultipartFile> fileList = List.of(files);
            noticeImageService.saveImages(noticeDto.getNoticeId(), fileList);
        }

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
        // 공지사항 삭제 시 서버 내의 물리 이미지 파일도 일괄 지우도록 서비스 호출 연동
        noticeImageService.deleteImagesByNoticeId(noticeId);

        boardService.deleteNotice(noticeId);
        return "redirect:/board";
    }

    // ==========================================
    // 4. 공지사항 수정 구역
    // ==========================================
    @PostMapping("/modify")
    public String modifyNotice(
            @ModelAttribute NoticeDto noticeDto,
            @RequestParam(value = "isPinned", required = false) String isPinned,
            @RequestParam(value = "files", required = false) MultipartFile[] files,           // 새로 추가된 이미지 파일들
            @RequestParam(value = "existingFiles", required = false) List<String> existingFiles) { // 유지해야 할 기존 이미지 파일명/URL 목록

        noticeDto.setIsPinned(isPinned == null ? 0 : 1);

        // 1. 게시글 기본 정보(제목, 내용 등) 수정
        boardService.modifyNotice(noticeDto);

        // 2. 이미지 추가 및 삭제 동기화 처리
        noticeImageService.updateBoardImages(noticeDto.getNoticeId(), files, existingFiles);

        return "redirect:/board";
    }

    // ==========================================
    // 5. 공지사항 단건 상세 조회 구역
    // ==========================================
    @GetMapping("/{noticeId}")
    public String detailNotice(@PathVariable("noticeId") Long noticeId, Model model) {
        NoticeDto notice = boardService.getNoticeById(noticeId);
        model.addAttribute("notice", notice);

        // 수정하기 창이나 상세 보기 모달이 열릴 때 기존 동기식 랜더링에 대응하기 위해
        // 해당 공지사항 ID에 첨부된 이미지 리스트를 미리 조회하여 모델에 함께 담아 전송합니다.
        List<NoticeImageDto> images = noticeImageService.getImagesByNoticeId(noticeId);
        model.addAttribute("images", images);

        return "board";
    }

    // ==========================================
    // 6. 상세조회 이미지 목록 비동기 반환 구역
    // ==========================================
    /**
     * 프론트엔드(board.js)의 fetch 요청을 받아 해당 게시글의 이미지 파일 정보 리스트를 JSON 배열로 반환합니다.
     */
    @GetMapping("/images")
    @ResponseBody
    public List<NoticeImageDto> getNoticeImages(@RequestParam("noticeId") Long noticeId) {
        return noticeImageService.getImagesByNoticeId(noticeId);
    }
}