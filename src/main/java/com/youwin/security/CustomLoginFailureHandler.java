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

                response.sendRedirect("/member/unlockDormant");
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

                response.sendRedirect("/member/restoreAccount");
                return;
            }
        }

        // 3. BANNED (이용 정지 계정)
        if ("BANNED".equals(message)) {
            String errorMsg = URLEncoder.encode("운영 정책 위반으로 이용이 정지된 계정입니다.", StandardCharsets.UTF_8);
            response.sendRedirect("/member/login?error=true&exception=" + errorMsg);
            return;
        }

        // 4. 아이디/비밀번호 불일치 등 일반 로그인 실패 영역
        if (memberId != null && !memberId.trim().isEmpty()) {

            // ① 이미 30분 일시 잠금 또는 3회 누적 영구 잠금 상태인지 확인!
            if (memberSecurityRepository.isLocked(memberId)) {
                MemberDto memberDto = memberService.getMemberById(memberId);
                if (memberDto != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("unlockMemberId", memberDto.getMemberId());
                    session.setAttribute("unlockMemberEmail", memberDto.getMemberEmail());
                }
                String errorMsg = URLEncoder.encode("지속적인 로그인 실패로 계정이 잠겼습니다. 30분 후 다시 시도하거나 이메일 인증으로 해제해 주세요.", StandardCharsets.UTF_8);
                response.sendRedirect("/member/login?error=true&exception=" + errorMsg + "&isLocked=true");
                return;
            }

            // ② DB에 실제 존재하는 회원인지 확인
            MemberDto memberDto = memberService.getMemberById(memberId);

            if (memberDto != null) {
                // 실패 카운트 1 증가
                memberSecurityRepository.increaseLoginFailCount(memberId);
                int failCount = memberSecurityRepository.getLoginFailCount(memberId);

                // 5회 실패 달성 시 -> 계정 잠금 처리 (lock_count + 1, locked_at = NOW())
                if (failCount >= 5) {
                    memberSecurityRepository.lockAccount(memberId);

                    HttpSession session = request.getSession();
                    session.setAttribute("unlockMemberId", memberDto.getMemberId());
                    session.setAttribute("unlockMemberEmail", memberDto.getMemberEmail());

                    String errorMsg = URLEncoder.encode("비밀번호를 5회 이상 틀려 계정이 잠겼습니다. 30분 후 다시 시도하거나 이메일 인증으로 해제해 주세요.", StandardCharsets.UTF_8);
                    response.sendRedirect("/member/login?error=true&exception=" + errorMsg + "&isLocked=true");
                    return;
                }
            }
        }

        // 5. 회원 정보가 없거나, 1~4회 실패 시 공통 실패 응답 (계정 존재 여부 노출 방지!)
        String errorMsg = URLEncoder.encode("아이디 또는 비밀번호가 올바르지 않습니다.", StandardCharsets.UTF_8);
        response.sendRedirect("/member/login?error=true&exception=" + errorMsg);
    }
}