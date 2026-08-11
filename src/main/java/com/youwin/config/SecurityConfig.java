package com.youwin.config;

import com.youwin.repository.AutoLoginRepository;
import com.youwin.security.AutoLoginFilter;
import com.youwin.security.CustomAuthenticationProvider;
import com.youwin.security.CustomLoginFailureHandler;
import com.youwin.security.CustomLoginSuccessHandler;
import jakarta.servlet.http.Cookie;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomLoginSuccessHandler customLoginSuccessHandler;
    private final CustomLoginFailureHandler customLoginFailureHandler;
    private final AutoLoginFilter autoLoginFilter;
    private final AutoLoginRepository autoLoginRepository;
    private final CustomAuthenticationProvider customAuthenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
                .csrf(csrf -> csrf.disable())
                .cors(cors -> cors.disable())
                // .authenticationProvider(customAuthenticationProvider)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/css/**", "/js/**", "/images/**", "/upload/**", "/error"
                        ).permitAll()
                        .requestMatchers(
                                "/member/update**", "/member/delete", "/member/mypage", "/member/settings"
                        ).authenticated()
                        .requestMatchers(
                                "/", "/api/**",
                                "/auth/**", "/member/**"
                        ).permitAll()
                        .requestMatchers(
                                "/index",
                                "/chatroom",
                                "/chatroom/**",
                                "/chat/**",
                                "/board/**"
                        ).authenticated()
                        .anyRequest().permitAll()
                )
                .formLogin(form -> form
                        .loginPage("/auth/login")
                        .loginProcessingUrl("/auth/login")
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
                        .maximumSessions(1)
                        .expiredUrl("/auth/login?expired=true")
                )
                .addFilterBefore(
                        autoLoginFilter,
                        UsernamePasswordAuthenticationFilter.class
                );

        return http.build();
    }

    // 기존의 config.getAuthenticationManager() 대신 ProviderManager를 직접 생성하여 1개만 지정
    @Bean
    public AuthenticationManager authenticationManager() {
        return new ProviderManager(customAuthenticationProvider);
    }

    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
}