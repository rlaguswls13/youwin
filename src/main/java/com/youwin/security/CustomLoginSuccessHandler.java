package com.youwin.security;

import com.youwin.repository.MemberSecurityRepository;
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
    private final MemberSecurityRepository memberSecurityRepository; // 👈 추가 주입!

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication)
            throws IOException, ServletException {

        CustomUserDetails user =
                (CustomUserDetails) authentication.getPrincipal();

        String memberId = user.getUsername();

        // 1. [보안] 로그인 성공했으므로 누적 실패 카운트 및 잠금 상태 0으로 리셋!
        memberSecurityRepository.resetLoginFailCount(memberId);

        // 2. 마지막 로그인 시간 갱신
        memberService.updateLastLoginAt(memberId);

        // 3. 자동로그인 체크박스 확인 ("on" 또는 "true")
        String rememberMe = request.getParameter("remember-me");
        if ("on".equals(rememberMe) || "true".equals(rememberMe)) {
            memberService.setupAutoLogin(memberId, response);
        }

        // 4. 로그인 성공 시 기본 이동할 URL 설정 (이전 페이지가 없을 시 홈으로)
        setDefaultTargetUrl("/");

        super.onAuthenticationSuccess(request, response, authentication);
    }
}