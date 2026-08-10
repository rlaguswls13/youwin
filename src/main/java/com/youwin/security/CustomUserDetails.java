package com.youwin.security;

import com.youwin.dto.MemberDto;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Getter
@EqualsAndHashCode(of = "memberId")
public class CustomUserDetails implements UserDetails {

    // 로그인한 회원 정보를 그대로 보관
    private final MemberDto memberDto;

    public CustomUserDetails(MemberDto memberDto) {
        this.memberDto = memberDto;
    }

    // ★ equals와 hashCode를 직접 작성하여 memberDto 내부의 memberId로 비교
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CustomUserDetails that = (CustomUserDetails) o;
        return memberDto != null && memberDto.getMemberId() != null &&
                memberDto.getMemberId().equals(that.getMemberDto().getMemberId());
    }

    @Override
    public int hashCode() {
        return memberDto != null && memberDto.getMemberId() != null ? memberDto.getMemberId().hashCode() : 0;
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
        String status = memberDto.getMemberStatus();
        return !"DORMANT".equals(status) && !"DELETED".equals(status);
    }

    // 활성화 여부 (핵심!)
    @Override
    public boolean isEnabled() {
        return !"BANNED".equals(memberDto.getMemberStatus());
    }
}