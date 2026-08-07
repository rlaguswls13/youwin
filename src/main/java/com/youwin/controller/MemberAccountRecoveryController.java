package com.youwin.controller;

import com.youwin.service.EmailVerificationService;
import com.youwin.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberAccountRecoveryController {

    private final MemberService memberService;
    private final EmailVerificationService emailVerificationService;

    // 1. 휴면 계정 해제 페이지 (GET)
    @GetMapping("/unlockDormant")
    public String unlockDormantPage(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("unlockMemberId");
        String memberEmail = (String) session.getAttribute("unlockMemberEmail");

        if (memberId == null || memberEmail == null) {
            return "redirect:/auth/login";
        }

        model.addAttribute("memberId", memberId);
        model.addAttribute("memberEmail", memberEmail);
        return "member/unlockDormant"; // /WEB-INF/views/member/unlockDormant.jsp
    }

    // 3. 탈퇴 취소/복구 페이지 (GET)
    @GetMapping("/restoreAccount")
    public String restoreAccountPage(HttpSession session, Model model) {
        String memberId = (String) session.getAttribute("restoreMemberId");
        String memberEmail = (String) session.getAttribute("restoreMemberEmail");

        if (memberId == null || memberEmail == null) {
            return "redirect:/auth/login";
        }

        model.addAttribute("memberId", memberId);
        model.addAttribute("memberEmail", memberEmail);
        return "member/restoreAccount"; // /WEB-INF/views/member/restoreAccount.jsp
    }
}