package com.youwin.controller;

import com.youwin.dto.BoardListResult;
import com.youwin.dto.BoardSearchCondition;
import com.youwin.dto.NoticeDto;
import com.youwin.service.NoticeImageService;
import com.youwin.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final NoticeService noticeService;
    private final NoticeImageService noticeImageService;

    // 0 & 1. 통합 공지사항 목록 조회 (/board 및 /board/)
    @GetMapping({"", "/"})
    public String boardList(BoardSearchCondition searchCondition, Model model) {

        // 서비스에 검색/페이징 조건 객체를 전달하고 결과(BoardListResult)를 반환받음
        BoardListResult result = noticeService.getNoticeList(searchCondition);

        // JSP 파일에서 사용하는 속성명(list, totalCount, condition 등)에 맞추어 모델에 담음
        model.addAttribute("list", result.getNoticeList());
        model.addAttribute("pageInfo", result.getPageInfo());
        model.addAttribute("condition", result.getSearchCondition());
        model.addAttribute("totalCount", result.getPageInfo().getTotalCount());

        return "board/list"; // WEB-INF/views/board/list.jsp
    }

    // 2. 글 작성 페이지 이동
    @GetMapping("/write")
    public String writeForm(Model model) {
        return "board/form"; // WEB-INF/views/board/form.jsp
    }

    // 3. 글 등록 처리 (등록 완료 후 /board로 이동)
    @PostMapping("/write")
    public String write(@ModelAttribute NoticeDto noticeDto,
                        @RequestParam(value = "imageFiles", required = false) List<MultipartFile> images) throws IOException {

        noticeService.writeNotice(noticeDto, images);
        return "redirect:/board";
    }

    // 4. 상세 조회 페이지 (/board/detail?noticeId= 형태로 들어오는 요청 대응 포함)
    @GetMapping("/detail")
    public String detailParam(@RequestParam("noticeId") Long noticeId, Model model) {
        return getDetailProcess(noticeId, model);
    }

    // RESTful 상세 조회 경로 겸용
    @GetMapping("/detail/{noticeId}")
    public String detailPath(@PathVariable("noticeId") Long noticeId, Model model) {
        return getDetailProcess(noticeId, model);
    }

    // 상세 조회 공통 로직 처리 메서드
    private String getDetailProcess(Long noticeId, Model model) {
        NoticeDto notice = noticeService.getNoticeById(noticeId);

        model.addAttribute("notice", notice);
        model.addAttribute("imageList", noticeImageService.getImagesByNoticeId(noticeId));

        return "board/detail"; // WEB-INF/views/board/detail.jsp
    }

    // 5. 수정 페이지 이동 (modify?noticeId= 형태 및 modify/{noticeId} 형태 모두 대응)
    @GetMapping({"/modify", "/modify/{noticeId}"})
    public String modifyForm(@PathVariable(value = "noticeId", required = false) Long pathId,
                             @RequestParam(value = "noticeId", required = false) Long paramId,
                             Model model) {
        Long noticeId = (pathId != null) ? pathId : paramId;
        NoticeDto notice = noticeService.getNoticeById(noticeId);

        model.addAttribute("mode", "edit");
        model.addAttribute("notice", notice);
        model.addAttribute("imageList", noticeImageService.getImagesByNoticeId(noticeId));

        return "board/form"; // WEB-INF/views/board/form.jsp
    }

    // 6. 수정 처리 (수정 완료 후 게시글 목록 /board로 이동)
    @PostMapping("/modify/{noticeId}")
    public String modify(@PathVariable("noticeId") Long noticeId,
                         @ModelAttribute NoticeDto noticeDto,
                         @RequestParam(value = "imageFiles", required = false) List<MultipartFile> newImages,
                         @RequestParam(value = "existingFiles", required = false) List<String> existingFiles) throws IOException {

        noticeService.modifyNotice(noticeId, noticeDto, newImages, existingFiles);

        return "redirect:/board";
    }

    // 7. 삭제 처리 (삭제 완료 후 /board로 이동)
    @PostMapping("/delete")
    public String delete(@RequestParam("noticeId") Long noticeId) {
        noticeService.deleteNotice(noticeId);
        return "redirect:/board";
    }
}