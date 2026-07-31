package com.youwin.security;

import com.youwin.dto.MemberDto;
import com.youwin.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
@RequiredArgsConstructor
public class CustomLoginFailureHandler implements AuthenticationFailureHandler {

    private final MemberService memberService;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {

        String memberId = request.getParameter("memberId");
        String message = exception.getMessage();

        // 1. DORMANT (휴면 계정) -> 이메일 인증 페이지로 이동
        if (exception instanceof LockedException || "DORMANT".equals(message)) {
            MemberDto member = memberService.getMemberById(memberId);
            if (member != null) {
                HttpSession session = request.getSession();
                session.setAttribute("unlockMemberId", member.getMemberId());
                session.setAttribute("unlockMemberEmail", member.getMemberEmail());

                response.sendRedirect("/member/unlockDormant"); // 휴면 해제 JSP
                return;
            }
        }

        // 2. DELETED (탈퇴 대기 계정) -> 탈퇴 취소 이메일 인증 페이지로 이동
        if ("DELETED".equals(message)) {
            MemberDto member = memberService.getMemberById(memberId);
            if (member != null) {
                HttpSession session = request.getSession();
                session.setAttribute("restoreMemberId", member.getMemberId());
                session.setAttribute("restoreMemberEmail", member.getMemberEmail());

                response.sendRedirect("/member/restoreAccount"); // 탈퇴 취소 JSP
                return;
            }
        }

        // 3. BANNED (이용 정지 계정)
        if ("BANNED".equals(message)) {
            String errorMsg = URLEncoder.encode("운영 정책 위반으로 이용이 정지된 계정입니다.", StandardCharsets.UTF_8);
            response.sendRedirect("/member/login?error=true&exception=" + errorMsg);
            return;
        }

        // 4. 아이디/비밀번호 불일치 등 일반 로그인 실패
        String errorMsg = URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", StandardCharsets.UTF_8);
        response.sendRedirect("/member/login?error=true&exception=" + errorMsg);
    }
}