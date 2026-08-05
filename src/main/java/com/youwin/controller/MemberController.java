package com.youwin.controller;

import com.youwin.dto.MemberDto;
import com.youwin.security.CustomUserDetails;
import com.youwin.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/join")
    public String join(MemberDto memberDto) {
        memberService.joinMember(memberDto);
        return "redirect:/login/login";
    }

    // 닉네임 변경
    @PostMapping("/updateNickname")
    public String updateNickname(
            @RequestParam("nickname") String nickname,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        memberService.updateNickname(
                userDetails.getUsername(),
                nickname);

        return "redirect:/member/settings";
    }

    // 전화번호 변경
    @PostMapping("/updatePhone")
    public String updatePhone(
            @RequestParam("memberPhone") String memberPhone,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        memberService.updatePhone(
                userDetails.getUsername(),
                memberPhone);

        return "redirect:/member/settings";
    }

    // 이메일 변경
    @PostMapping("/updateEmail")
    public String updateEmail(
            @RequestParam("memberEmail") String memberEmail,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        memberService.updateEmail(
                userDetails.getUsername(),
                memberEmail);

        return "redirect:/member/settings";
    }

    // 프로필 이미지 변경
    @PostMapping("/updateProfileImage")
    public String updateProfileImage(
            @AuthenticationPrincipal CustomUserDetails userDetails,
            @RequestParam("deleteProfile") boolean deleteProfile,
            @RequestParam(value = "profile", required = false) MultipartFile profileFile,
            RedirectAttributes redirectAttributes) {

        memberService.updateProfileImage(
                userDetails.getMemberDto().getMemberId(),
                profileFile,
                deleteProfile);

        MemberDto updatedMember = memberService.getMemberById(
                userDetails.getMemberDto().getMemberId());

        CustomUserDetails newUserDetails = new CustomUserDetails(updatedMember);

        Authentication newAuth = new UsernamePasswordAuthenticationToken(
                newUserDetails,
                newUserDetails.getPassword(),
                newUserDetails.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(newAuth);

        return "redirect:/member/settings";
    }

    // 비밀번호 변경
    @PostMapping("/updatePasswordInSettings")
    public String updatePasswordInSettings(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            RedirectAttributes rttr) {

        try {
            memberService.updatePasswordInSettings(
                    userDetails.getUsername(),
                    currentPassword,
                    newPassword);

            rttr.addFlashAttribute(
                    "successMessage",
                    "비밀번호가 변경되었습니다.");

        } catch (IllegalArgumentException e) {
            rttr.addFlashAttribute(
                    "errorMessage",
                    e.getMessage());
        }
        return "redirect:/member/settings";
    }

    // 회원 탈퇴
    @PostMapping("/delete")
    public String deleteMember(
            @RequestParam("password") String password,
            HttpServletRequest request,
            HttpServletResponse response,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            RedirectAttributes rttr) {

        if (userDetails == null) {
            return "redirect:/login/login";
        }

        String memberId = userDetails.getUsername();

        boolean isPasswordMatch = memberService.checkPassword(memberId, password);

        if (!isPasswordMatch) {
            rttr.addFlashAttribute("errorMessage", "비밀번호가 일치하지 않습니다.");
            return "redirect:/member/settings";
        }

        try {
            memberService.deleteMember(memberId);

            Cookie[] cookies = request.getCookies();

            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("remember-me".equals(cookie.getName())) {
                        memberService.removeAutoLoginToken(cookie.getValue());
                        cookie.setPath("/");
                        cookie.setMaxAge(0);
                        response.addCookie(cookie);
                        break;
                    }
                }
            }

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null) {
                new SecurityContextLogoutHandler().logout(request, response, authentication);
            }

            rttr.addFlashAttribute("successMessage", "계정 삭제 신청이 완료되었습니다.");

            return "redirect:/";

        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("errorMessage", "탈퇴 처리 중 오류가 발생했습니다.");
            return "redirect:/member/settings";
        }
    }

    // ==========================================
    // View 페이지 이동 (GET 매핑)
    // ==========================================
    @GetMapping("/joinStep1")
    public String joinStep1() {
        return "member/joinStep1";
    }

    @GetMapping("/joinStep2")
    public String joinStep2() {
        return "member/joinStep2";
    }

    @GetMapping("/mypage")
    public String mypageForm(
            @AuthenticationPrincipal CustomUserDetails user,
            Model model) {

        MemberDto memberDto = user.getMemberDto();
        model.addAttribute("memberDto", memberDto);

        return "member/mypage";
    }

    @GetMapping("/settings")
    public String settingsForm(@AuthenticationPrincipal CustomUserDetails user, Model model) {

        MemberDto memberDto = memberService.getMemberById(user.getUsername());
        model.addAttribute("memberDto", memberDto);

        return "member/settings";
    }

    // 아이디 찾기 페이지 이동
    @GetMapping("/findId")
    public String findIdForm() {
        return "member/findId";
    }

    // 비밀번호 찾기(및 재설정 통합) 페이지 이동
    @GetMapping("/findPassword")
    public String findPasswordForm() {
        return "member/findPassword";
    }

}