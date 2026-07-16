package com.youwin.member.mapper;

import com.youwin.member.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface MemberMapper {
    // 회원 정보를 DB에 저장하는 메소드
    void insertMember(MemberDto memberdto);

    // (선택) 회원가입 시 아이디 중복 체크를 위한 메소드
    int checkIdExists(String memberId);
}
