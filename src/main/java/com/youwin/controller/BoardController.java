package com.youwin.controller;

import com.youwin.dto.BoardListResult;
import com.youwin.dto.BoardSearchCondition;
import com.youwin.dto.NoticeDto;
import com.youwin.security.CustomUserDetails;
import com.youwin.service.NoticeImageService;
import com.youwin.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
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

    /**
     * 🟢 컨트롤러 전용 관리자 판별 메서드 (외부 파일 수정 없음)
     * 시큐리티가 가진 권한 목록이나 사용자 정보를 활용하여 관리자 여부를 판별합니다.
     */
    private boolean checkAdmin() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }

        // 1. GrantedAuthority 권한 목록에서 관리자 권한이 있는지 체크
        for (GrantedAuthority authority : authentication.getAuthorities()) {
            String authName = authority.getAuthority();
            if (authName != null && (authName.contains("ADMIN") || authName.contains("ROLE_ADMIN"))) {
                return true;
            }
        }

        // 2. Principal 내부 객체 검사
        Object principal = authentication.getPrincipal();
        if (principal instanceof CustomUserDetails) {
            CustomUserDetails userDetails = (CustomUserDetails) principal;
            if (userDetails.getMemberDto() != null) {
                String memberId = userDetails.getMemberDto().getMemberId();
                // 관리자 아이디인 경우 예외적으로 즉시 허용 (필요시 아이디 추가 가능)
                if ("zxcv1234".equals(memberId)) {
                    return true;
                }
            }
        }
        return false;
    }

    // 0 & 1. 통합 공지사항 목록 조회 (/board 및 /board/) - 누구나 조회 가능
    @GetMapping({"", "/"})
    public String boardList(BoardSearchCondition searchCondition, Model model) {

        BoardListResult result = noticeService.getNoticeList(searchCondition);

        model.addAttribute("list", result.getNoticeList());
        model.addAttribute("pageInfo", result.getPageInfo());
        model.addAttribute("condition", result.getSearchCondition());
        model.addAttribute("totalCount", result.getPageInfo().getTotalCount());
        model.addAttribute("isAdmin", checkAdmin()); // 관리자 여부 전달

        return "board/list";
    }

    // 2. 글 작성 페이지 이동
    @GetMapping("/write")
    public String writeForm(Model model) {
        if (!checkAdmin()) {
            return "redirect:/board";
        }
        model.addAttribute("isAdmin", checkAdmin());
        return "board/form";
    }

    // 3. 글 등록 처리
    @PostMapping("/write")
    public String write(@ModelAttribute NoticeDto noticeDto,
                        @RequestParam(value = "imageFiles", required = false) List<MultipartFile> images) throws IOException {

        if (!checkAdmin()) {
            return "redirect:/board";
        }

        noticeService.writeNotice(noticeDto, images);
        return "redirect:/board";
    }

    // 4. 상세 조회 페이지
    @GetMapping("/detail")
    public String detailParam(@RequestParam("noticeId") Long noticeId, Model model) {
        return getDetailProcess(noticeId, model);
    }

    @GetMapping("/detail/{noticeId}")
    public String detailPath(@PathVariable("noticeId") Long noticeId, Model model) {
        return getDetailProcess(noticeId, model);
    }

    private String getDetailProcess(Long noticeId, Model model) {
        NoticeDto notice = noticeService.getNoticeById(noticeId);

        model.addAttribute("notice", notice);
        model.addAttribute("imageList", noticeImageService.getImagesByNoticeId(noticeId));
        model.addAttribute("isAdmin", checkAdmin()); // 관리자 여부 전달

        return "board/detail";
    }

    // 5. 수정 페이지 이동
    @GetMapping({"/modify", "/modify/{noticeId}"})
    public String modifyForm(@PathVariable(value = "noticeId", required = false) Long pathId,
                             @RequestParam(value = "noticeId", required = false) Long paramId,
                             Model model) {

        if (!checkAdmin()) {
            return "redirect:/board";
        }

        Long noticeId = (pathId != null) ? pathId : paramId;
        NoticeDto notice = noticeService.getNoticeById(noticeId);

        model.addAttribute("mode", "edit");
        model.addAttribute("notice", notice);
        model.addAttribute("imageList", noticeImageService.getImagesByNoticeId(noticeId));
        model.addAttribute("isAdmin", checkAdmin());

        return "board/form";
    }

    // 6. 수정 처리
    @PostMapping("/modify/{noticeId}")
    public String modify(@PathVariable("noticeId") Long noticeId,
                         @ModelAttribute NoticeDto noticeDto,
                         @RequestParam(value = "imageFiles", required = false) List<MultipartFile> newImages,
                         @RequestParam(value = "existingFiles", required = false) List<String> existingFiles) throws IOException {

        if (!checkAdmin()) {
            return "redirect:/board";
        }

        noticeService.modifyNotice(noticeId, noticeDto, newImages, existingFiles);

        return "redirect:/board";
    }

    // 7. 삭제 처리
    @PostMapping("/delete")
    public String delete(@RequestParam("noticeId") Long noticeId) {
        if (!checkAdmin()) {
            return "redirect:/board";
        }

        noticeService.deleteNotice(noticeId);
        return "redirect:/board";
    }
}