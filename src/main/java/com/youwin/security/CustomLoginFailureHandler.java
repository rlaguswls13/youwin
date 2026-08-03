package com.youwin.security;

import com.youwin.dto.MemberDto;
import com.youwin.repository.MemberSecurityRepository;
import com.youwin.service.MemberService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
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
    private final MemberSecurityRepository memberSecurityRepository;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception) throws IOException, ServletException {

        String memberId = request.getParameter("memberId");
        String message = exception.getMessage();

        // 1. DORMANT (휴면 계정) -> 이메일 인증 페이지로 이동
        if ("DORMANT".equals(message)) {
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
        if (memberId != null && !memberId.trim().isEmpty()) {

            // 1) DB에 실제 존재하는 회원인지 먼저 확인!
            MemberDto memberDto = memberService.getMemberById(memberId);

            // 2) 실제 존재하는 회원일 때만 실패 카운트 증가 (외래키 에러 방지)
            if (memberDto != null) {
                memberSecurityRepository.increaseLoginFailCount(memberId);
                int failCount = memberSecurityRepository.getLoginFailCount(memberId);

                // 5회 달성 시 계정 잠금 처리
                if (failCount >= 5) {
                    memberSecurityRepository.lockAccount(memberId);

                    HttpSession session = request.getSession();
                    session.setAttribute("unlockMemberId", memberDto.getMemberId());
                    session.setAttribute("unlockMemberEmail", memberDto.getMemberEmail());

                    String errorMsg = URLEncoder.encode("비밀번호를 5회 틀려 계정이 잠겼습니다. 이메일 인증으로 해제해주세요.", StandardCharsets.UTF_8);
                    response.sendRedirect("/member/login?error=true&exception=" + errorMsg + "&isLocked=true");
                    return;
                }

                // 1~4회 실패 시 실패 횟수 안내
                String errorMsg = URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다. (" + failCount + "/5회 실패)", StandardCharsets.UTF_8);
                response.sendRedirect("/member/login?error=true&exception=" + errorMsg);
                return;
            }
        }

        // 3) 회원 정보가 없거나 아이디 입력이 비어있는 경우 (카운트 증가 없이 단순 안내)
        String errorMsg = URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", StandardCharsets.UTF_8);
        response.sendRedirect("/member/login?error=true&exception=" + errorMsg);
    }
}