package com.youwin.interceptor;

import com.youwin.dto.MemberDto;
import com.youwin.repository.AutoLoginRepository;
import com.youwin.service.MemberService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.util.WebUtils;

@Component
@RequiredArgsConstructor
public class AutoLoginInterceptor implements HandlerInterceptor {

    private final AutoLoginRepository autoLoginRepository;
    private final MemberService memberService; // 회원 정보 조회가 가능한 서비스

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        MemberDto loginUser = (MemberDto) session.getAttribute("loginUser");

        // 1. 현재 로그인 세션이 '없는' 경우에만 자동 로그인 검사 진행
        if (loginUser == null) {
            // 브라우저에서 보낸 쿠키 중 "remember-me" 쿠키 찾기
            Cookie autoLoginCookie = WebUtils.getCookie(request, "remember-me");

            if (autoLoginCookie != null) {
                String token = autoLoginCookie.getValue();

                // 2. DB에서 토큰으로 유저 ID 조회 (만료시간 지나지 않은 토큰만)
                String memberId = autoLoginRepository.findMemberIdByToken(token);

                if (memberId != null) {
                    // 3. 만들어두신 getMemberById 메서드 호출! (비밀번호 제거 처리까지 자동 완료)
                    MemberDto memberDto = memberService.getMemberById(memberId);

                    if (memberDto != null) {
                        session.setAttribute("loginUser", memberDto);
                    }
                } else {
                    // DB에 없거나 만료된 토큰인 경우, 쓰레기 쿠키 삭제
                    Cookie cookie = new Cookie("remember-me", null);
                    cookie.setPath("/");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }
            }
        }

        return true;
    }
}