package com.youwin.config;

import com.youwin.repository.AutoLoginRepository;
import com.youwin.security.*;
import jakarta.servlet.http.Cookie;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomUserDetailsService userDetailsService;
    private final CustomAuthenticationProvider customAuthenticationProvider;
    private final CustomLoginSuccessHandler customLoginSuccessHandler;
    private final CustomLoginFailureHandler customLoginFailureHandler;
    private final AutoLoginFilter autoLoginFilter;
    private final AutoLoginRepository autoLoginRepository; // DB 토큰 삭제용 추가

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
                .csrf(csrf -> csrf.disable())
                .userDetailsService(userDetailsService)
                .authenticationProvider(customAuthenticationProvider)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/css/**", "/js/**", "/images/**", "/upload/**", "/error"
                        ).permitAll()
                        .requestMatchers(
                                "/", "/api/member/**",
                                "/member/login",
                                "/member/unlockDormant",
                                "/member/restoreAccount"
                        ).permitAll()
                        .requestMatchers(
                                "/member/mypage", "/member/settings", "/member/update**", "/member/delete"

                        ).authenticated()
//                        .requestMatchers(
//                                "/member/**")
//                        .anonymous()
                        .requestMatchers(
                                "/index",
                                "/chatroom",
                                "/chatroom/**",
                                "/chat/**"
                        ).authenticated()
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/member/login")
                        .loginProcessingUrl("/member/login")
                        .usernameParameter("memberId")
                        .passwordParameter("memberPassword")
                        .successHandler(customLoginSuccessHandler)
                        .failureHandler(customLoginFailureHandler)
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/member/logout")
                        .logoutSuccessUrl("/")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID", "remember-me")
                        .addLogoutHandler((request, response, authentication) -> {
                            Cookie[] cookies = request.getCookies();
                            if (cookies != null) {
                                for (Cookie cookie : cookies) {
                                    if ("remember-me".equals(cookie.getName())) {
                                        autoLoginRepository.deleteByToken(cookie.getValue());

                                        // 브라우저 쿠키 확실하게 만료시키기
                                        Cookie deleteCookie = new Cookie("remember-me", null);
                                        deleteCookie.setPath("/");
                                        deleteCookie.setMaxAge(0);
                                        response.addCookie(deleteCookie);
                                        break;
                                    }
                                }
                            }
                        })
                )
                .sessionManagement(session -> session
                                .maximumSessions(1) // 동시 접속 1명으로 제한
                                .expiredUrl("/member/login?expired=true") // 기존 세션 만료 시 리다이렉트 페이지
                )
                .addFilterBefore(
                        autoLoginFilter,
                        UsernamePasswordAuthenticationFilter.class
                );

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
}