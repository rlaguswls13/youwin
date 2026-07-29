package com.youwin.security;

import com.youwin.dto.MemberDto;
import com.youwin.repository.AutoLoginRepository;
import com.youwin.service.MemberService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
@RequiredArgsConstructor
public class AutoLoginFilter extends OncePerRequestFilter {

    private final AutoLoginRepository autoLoginRepository;
    private final MemberService memberService;

    // 세션에 SecurityContext를 바인딩해주는 객체
    private final HttpSessionSecurityContextRepository securityContextRepository =
            new HttpSessionSecurityContextRepository();

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws ServletException, IOException {

        Authentication authentication =
                SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null
                && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {
            filterChain.doFilter(request, response);
            return;
        }

        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember-me".equals(cookie.getName())) {

                    String token = cookie.getValue();
                    String memberId = autoLoginRepository.findMemberIdByToken(token);

                    if (memberId != null) {
                        MemberDto memberDto = memberService.getMemberById(memberId);

                        if (memberDto != null) {
                            CustomUserDetails userDetails = new CustomUserDetails(memberDto);

                            UsernamePasswordAuthenticationToken auth =
                                    new UsernamePasswordAuthenticationToken(
                                            userDetails,
                                            null,
                                            userDetails.getAuthorities());

                            // Context 생성 및 저장
                            // AutoLoginFilter.java 의 context 저장 부분
                            SecurityContext context = SecurityContextHolder.createEmptyContext();
                            context.setAuthentication(auth);
                            SecurityContextHolder.setContext(context);

                            // 세션에도 넣어줘야 다음 페이지 이동해도 로그인이 유지됩니다.
                            request.getSession(true);
                            securityContextRepository.saveContext(context, request, response);
                        }
                    } else {
                        // DB에 없는 만료/잘못된 토큰이면 쿠키 지워주기
                        Cookie invalidCookie = new Cookie("remember-me", null);
                        invalidCookie.setMaxAge(0);
                        invalidCookie.setPath("/");
                        response.addCookie(invalidCookie);
                    }
                    break;
                }
            }
        }

        filterChain.doFilter(request, response);
    }
}