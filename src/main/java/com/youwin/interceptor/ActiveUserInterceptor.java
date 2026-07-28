package com.youwin.interceptor;

import com.youwin.dto.MemberDto;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component; // ★ Import 확인!
import org.springframework.web.servlet.HandlerInterceptor;

@Component // ★ 이 어노테이션이 누락되어 발생한 에러입니다!
public class ActiveUserInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        MemberDto loginUser = (MemberDto) session.getAttribute("loginUser");

        // 1. 비로그인 사용자 -> 로그인 페이지로 이동
        if (loginUser == null) {
            response.sendRedirect("/member/login");
            return false;
        }

        // 2. ACTIVE 상태가 아닌 유저 (DELETED 등) -> 세션 지우고 로그인 페이지로 튕겨내기
        if (!"ACTIVE".equals(loginUser.getMemberStatus())) {
            session.removeAttribute("loginUser");
            response.sendRedirect("/member/login?error=deleted");
            return false;
        }

        return true; // ACTIVE 유저만 통과
    }
}