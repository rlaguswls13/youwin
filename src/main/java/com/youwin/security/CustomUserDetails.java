package com.youwin.security;

import com.youwin.dto.MemberDto;
import lombok.Getter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Getter
public class CustomUserDetails implements UserDetails {

    // 로그인한 회원 정보를 그대로 보관
    private final MemberDto memberDto;

    public CustomUserDetails(MemberDto memberDto) {
        this.memberDto = memberDto;
    }

    // 회원 권한 반환 (나중을 위한 기능)
    @Override
    public Collection<? extends SimpleGrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority("ROLE_USER"));
    }

    @Override
    public String getPassword() {
        return memberDto.getMemberPassword();
    }

    @Override
    public String getUsername() {
        return memberDto.getMemberId();
    }

    // 계정 잠금 여부 (DORMANT, DELETED 상태면 잠김 처리 -> LockedException 발생)
    @Override
    public boolean isAccountNonLocked() {
        return !"DORMANT".equals(memberDto.getMemberStatus());
    }

    // 활성화 여부 (핵심!)
    @Override
    public boolean isEnabled() {
        return !"BANNED".equals(memberDto.getMemberStatus());
    }
}