package com.youwin.security;

import com.youwin.dto.MemberDto;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class CustomAuthenticationProvider implements AuthenticationProvider {

    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication)
            throws AuthenticationException {

        String memberId = authentication.getName();
        String password = authentication.getCredentials().toString();

        // 1. DB 회원 정보 조회
        CustomUserDetails userDetails =
                (CustomUserDetails) userDetailsService.loadUserByUsername(memberId);

        // 2. 비밀번호 검증
        if (!passwordEncoder.matches(password, userDetails.getPassword())) {
            throw new BadCredentialsException("비밀번호가 일치하지 않습니다.");
        }

        // 3. 회원 상태(member_status) 검증
        MemberDto member = userDetails.getMemberDto();
        String status = member != null ? member.getMemberStatus() : "ACTIVE";

        // 휴면 계정 -> LockedException 발생 (LoginFailureHandler에서 감지 후 이메일 인증으로 이동)
        if ("DORMANT".equals(status)) {
            throw new LockedException("DORMANT");
        }

        // 탈퇴 대기 계정 -> DisabledException 발생 (LoginFailureHandler에서 감지 후 복구/취소 페이지로 이동)
        if ("DELETED".equals(status)) {
            throw new DisabledException("DELETED");
        }

        // 이용 정지 계정 -> DisabledException 발생 (LoginFailureHandler에서 감지 후 정지 안내)
        if ("BANNED".equals(status)) {
            throw new DisabledException("BANNED");
        }

        // 4. 로그인 성공 (ACTIVE 상태)
        return new UsernamePasswordAuthenticationToken(
                userDetails,
                null,
                userDetails.getAuthorities()
        );
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
    }
}