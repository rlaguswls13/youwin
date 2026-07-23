package com.youwin.controller;

import com.youwin.dto.LoginRequestDto;
import com.youwin.dto.MemberDto;
import com.youwin.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
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
    public String join(MemberDto memberDto, MultipartFile profile) {
        // INSERT 서비스 호출
        memberService.joinMember(memberDto);

        return "redirect:/member/login";
    }

    @PostMapping("/login")
    public String login(
            LoginRequestDto loginDto,
            @RequestParam(value = "autoLogin", required = false) boolean autoLogin, // 🎯 1. 체크박스 값 (기본값 false)
            HttpSession session,
            HttpServletResponse response,
            RedirectAttributes rttr) {
        try {
            // 서비스 실행
            MemberDto loginUser = memberService.login(loginDto);
            session.setAttribute("loginUser", loginUser);

            // 3. [자동 로그인 체크 시 실행]
            if (autoLogin) {
                memberService.setupAutoLogin(loginUser.getMemberId(), response);
            }

            return "redirect:/";

        } catch (IllegalArgumentException e) {
            // 화면에 보여줄 문구를 담아서 전달
            rttr.addFlashAttribute("errorMessage", e.getMessage());
            // 입력했던 아이디 값도 같이 전달
            rttr.addFlashAttribute("savedMemberId", loginDto.getMemberId());
            return "redirect:/member/login";
        }
    }

    @GetMapping("/logout")
    public String logout(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session) {

        // 1. 쿠키에서 remember-me 토큰 꺼내서 DB & 쿠키 삭제
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember-me".equals(cookie.getName())) {
                    String token = cookie.getValue();

                    // DB 토큰 삭제
                    memberService.removeAutoLoginToken(token);

                    // 브라우저 쿠키 삭제 (유효기간 0 설정)
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        // 2. 세션 파기
        session.invalidate();

        return "redirect:/";
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

    @GetMapping("/mypage")
    public String mypageForm() {
        return "member/mypage";
    }

    @GetMapping("/settings")
    public String settingsForm() { return "member/settings"; }

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
