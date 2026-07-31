package com.youwin.security;

import com.youwin.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class CustomLoginSuccessHandler
        extends SavedRequestAwareAuthenticationSuccessHandler {

    private final MemberService memberService;

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication)
            throws IOException, ServletException {

        CustomUserDetails user =
                (CustomUserDetails) authentication.getPrincipal();

        // 마지막 로그인 시간 갱신
        memberService.updateLastLoginAt(user.getUsername());

        // 자동로그인 체크박스 확인 ("on" 또는 "true")
        String rememberMe = request.getParameter("remember-me");
        if ("on".equals(rememberMe) || "true".equals(rememberMe)) {
            memberService.setupAutoLogin(user.getUsername(), response);
        }

        // 로그인 성공 시 기본 이동할 URL이 지정되지 않았다면 홈("/")으로 이동
        setDefaultTargetUrl("/");

        super.onAuthenticationSuccess(request, response, authentication);
    }
}