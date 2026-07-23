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
}
