package com.youwin.controller;

import com.youwin.dto.NoticeDto;
import com.youwin.service.NoticeService;
import com.youwin.service.NoticeImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final NoticeService noticeService;
    private final NoticeImageService noticeImageService;

    // 1. 공지사항 목록 조회 (페이징 및 검색 포함)
    @GetMapping
    public String boardList(@RequestParam(value = "page", defaultValue = "1") int page,
                            @RequestParam(value = "category", defaultValue = "all") String category,
                            @RequestParam(value = "keyword", defaultValue = "") String keyword,
                            Model model) {

        int limit = 10;
        int offset = (page - 1) * limit;

        Map<String, Object> params = new HashMap<>();
        params.put("offset", offset);
        params.put("limit", limit);
        params.put("category", category);
        params.put("keyword", keyword);

        List<NoticeDto> list = noticeService.getNoticesWithPaging(params);
        int totalCount = noticeService.getTotalCount(params);

        com.youwin.dto.PageInfo pageInfo = new com.youwin.dto.PageInfo(page, totalCount);

        model.addAttribute("list", list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("category", category);
        model.addAttribute("keyword", keyword);

        return "board/list";
    }

    // 2. 글 작성 페이지 이동
    @GetMapping("/write")
    public String writeForm(Model model) {
        return "board/form";
    }

    // 3. 글 등록 처리
    @PostMapping("/write")
    public String write(@ModelAttribute NoticeDto noticeDto) {
        noticeService.writeNotice(noticeDto);
        return "redirect:/board";
    }

    // 4. 상세 조회 페이지
    @GetMapping("/detail")
    public String detail(@RequestParam("noticeId") Long noticeId, Model model) {
        NoticeDto notice = noticeService.getNoticeById(noticeId);
        model.addAttribute("notice", notice);
        model.addAttribute("imageList", noticeImageService.getImagesByNoticeId(noticeId));

        return "board/detail";
    }

    // 5. 수정 페이지 이동 (데이터와 기존 이미지 목록을 담아서 화면으로 전달)
    @GetMapping("/modify")
    public String modifyForm(@RequestParam("noticeId") Long noticeId, Model model) {
        NoticeDto notice = noticeService.getNoticeById(noticeId);
        model.addAttribute("notice", notice);
        model.addAttribute("imageList", noticeImageService.getImagesByNoticeId(noticeId));

        return "board/form";
    }

    // 6. 수정 처리 (수정 완료 후 상세 페이지 대신 목록 페이지로 이동하도록 변경)
    @PostMapping("/modify")
    public String modify(@ModelAttribute NoticeDto noticeDto,
                         @RequestParam(value = "existingFiles", required = false) List<String> existingFiles) {
        noticeService.modifyNotice(noticeDto, existingFiles);
        return "redirect:/board";
    }

    // 7. 삭제 처리
    @PostMapping("/delete")
    public String delete(@RequestParam("noticeId") Long noticeId) {
        noticeService.deleteNotice(noticeId);
        return "redirect:/board";
    }
}