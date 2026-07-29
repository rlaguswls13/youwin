package com.youwin.controller;

import com.youwin.dto.MemberDto;
import com.youwin.security.CustomUserDetails;
import com.youwin.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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

        return "redirect:/member/login";
    }

    // 아이디 찾기 처리
    @PostMapping("/findId")
    public String findId(@RequestParam("memberName") String memberName,
                         @RequestParam("memberEmail") String memberEmail,
                         Model model) {
        try {
            String foundMemberId = memberService.findMemberId(memberName, memberEmail);

            // 아이디 찾기 성공시 JSP로 찾은 아이디 전달
            model.addAttribute("foundMemberId", foundMemberId);
        } catch (IllegalArgumentException e) {
            // 실패 시 에러 메시지 전달
            model.addAttribute("errorMessage", e.getMessage());
        }

        return "member/findId"; // 결과를 담아서 다시 findId.jsp로 돌아감
    }

    // 비밀번호 찾기
    // 1. 정보 확인 요청 (아이디 + 이메일 일치 여부 검증)
    @PostMapping("/findPassword")
    public String findPassword(@RequestParam("memberId") String memberId,
                               @RequestParam("memberEmail") String memberEmail,
                               HttpSession session,
                               Model model) {
        try {
            // 아이디+이메일 일치 검증
            memberService.checkMemberExist(memberId, memberEmail);

            // 본인 인증이 확인된 아이디를 세션에 임시 저장 (다음 페이지에서 쓰기 위함)
            session.setAttribute("resetMemberId", memberId);

            // 새 비밀번호 설정 페이지로 이동
            return "redirect:/member/resetPassword";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "member/findPassword";
        }
    }

    // 2. 새 비밀번호 변경 처리
    @PostMapping("/resetPassword")
    public String resetPassword(@RequestParam("newPassword") String newPassword,
                                HttpSession session,
                                Model model) {

        String memberId = (String) session.getAttribute("resetMemberId");

        if (memberId == null) {
            return "redirect:/member/findPassword";
        }

        // 서비스 호출 (BCrypt 암호화 후 DB 저장)
        memberService.updatePassword(memberId, newPassword);

        // 세션 정리
        session.removeAttribute("resetMemberId");

        // 로그인 페이지로 이동하면서 성공 파라미터 전달
        return "redirect:/member/login?resetSuccess=true";
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

        // 1. DB 업데이트 (삭제 요청 시 null 처리)
        memberService.updateProfileImage(
                userDetails.getMemberDto().getMemberId(),
                profileFile,
                deleteProfile);

        // 2. DB에서 최신 회원 정보 조회 (profileImage가 null인 상태)
        MemberDto updatedMember = memberService.getMemberById(
                userDetails.getMemberDto().getMemberId());

        // 🟢 3. 새로 조회한 DTO로 CustomUserDetails 객체 '신규 생성'
        CustomUserDetails newUserDetails = new CustomUserDetails(updatedMember);

        // 🟢 4. SecurityContext의 Authentication 객체 교체 (세션 갱신)
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
            @RequestParam("currentPassword")
            String currentPassword,
            @RequestParam("newPassword")
            String newPassword,
            @AuthenticationPrincipal
            CustomUserDetails userDetails,

            RedirectAttributes rttr){

        try{
            memberService.updatePasswordInSettings(
                    userDetails.getUsername(),
                    currentPassword,
                    newPassword);

            rttr.addFlashAttribute(
                    "successMessage",
                    "비밀번호가 변경되었습니다.");

        }catch (IllegalArgumentException e){
            rttr.addFlashAttribute(
                    "errorMessage",
                    e.getMessage());
        }
        return "redirect:/member/settings";
    }


    @PostMapping("/delete")
    public String deleteMember(
            @RequestParam("password") String password,
            HttpServletRequest request,
            HttpServletResponse response,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            RedirectAttributes rttr) {

        // authenticated()로 보호되어 있으므로 사실상 null이 될 일은 거의 없지만
        // 안전하게 한 번 더 검사
        if (userDetails == null) {
            return "redirect:/member/login";
        }

        String memberId = userDetails.getUsername();

        boolean isPasswordMatch =
                memberService.checkPassword(memberId, password);

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


            // Spring Security 로그아웃
            // SecurityContext + Session 모두 삭제
            Authentication authentication =
                    SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null) {
                new SecurityContextLogoutHandler()
                        .logout(request, response, authentication);
            }

            rttr.addFlashAttribute(
                    "successMessage",
                    "계정 삭제 신청이 완료되었습니다.");

            return "redirect:/";

        } catch (Exception e) {

            e.printStackTrace();

            rttr.addFlashAttribute(
                    "errorMessage",
                    "탈퇴 처리 중 오류가 발생했습니다.");

            return "redirect:/member/settings";
        }
    }

    // view 이동
    @GetMapping("/joinStep1")
    public String joinStep1() { return "member/joinStep1"; }

    @GetMapping("/joinStep2")
    public String joinStep2() {
        return "member/joinStep2";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    @GetMapping("/myPage")
    public String myPage(
            @AuthenticationPrincipal CustomUserDetails user,
            Model model){

        MemberDto memberDto = user.getMemberDto();

        model.addAttribute("memberDto", memberDto);

        return "member/myPage";
    }

    @GetMapping("/settings")
    public String settingsForm(@AuthenticationPrincipal CustomUserDetails user,
                               Model model) {

        MemberDto memberDto = memberService.getMemberById(user.getUsername());

        model.addAttribute("memberDto", memberDto);

        return "member/settings";
    }

    @GetMapping("/findId")
    public String findIdForm() { return "member/findId"; }

    @GetMapping("/findPassword")
    public String findPasswordForm() { return "member/findPassword"; }

    @GetMapping("/resetPassword")
    public String resetPasswordPage(HttpSession session) {
        // 1번 단계를 거치지 않고 직접 주소쳐서 들어온 경우 튕겨내기
        if (session.getAttribute("resetMemberId") == null) {
            return "redirect:/member/findPassword";
        }
        return "member/resetPassword";
    }

}
