package com.youwin.service;

import com.youwin.dto.MemberDto;
import com.youwin.repository.MemberRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MemberService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public MemberService(MemberRepository memberRepository, PasswordEncoder passwordEncoder) {
        this.memberRepository = memberRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public void join(MemberDto member) {
        if (isMemberIdTaken(member.getMemberId())) {
            throw new IllegalArgumentException("이미 사용 중인 회원 아이디입니다.");
        }

        member.setMemberPassword(passwordEncoder.encode(member.getMemberPassword()));
        memberRepository.save(member);
    }

    @Transactional(readOnly = true)
    public boolean isMemberIdTaken(String memberId) {
        return memberRepository.countById(memberId) > 0;
    }
}
