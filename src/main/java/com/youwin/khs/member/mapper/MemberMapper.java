package com.youwin.khs.member.mapper;

import com.youwin.khs.member.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberMapper {
    // 회원 정보를 DB에 저장하는 메소드
    int insertMember(MemberDto memberdto);

    // (선택) 회원가입 시 아이디 중복 체크를 위한 메소드
    int checkId(String memberId);
}
