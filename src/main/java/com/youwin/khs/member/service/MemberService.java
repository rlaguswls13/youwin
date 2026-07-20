package com.youwin.khs.member.service;

import com.youwin.khs.member.dto.MemberDto;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;

public interface MemberService {
    // 1. 회원가입
    void join(MemberDto memberDto, MultipartFile profileImage) throws IOException;
    // 2. 아이디 중복 체크
    boolean isMemberIdCheck(String memberId);
}
