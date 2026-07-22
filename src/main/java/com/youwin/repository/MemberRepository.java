package com.youwin.repository;

import com.youwin.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberRepository {
    void insertMember(MemberDto member);
    // 아이디 개수 조회 (존재하면 1 이상, 없으면 0)
    int countByMemberId(@Param("memberId") String memberId);
    // 닉네임 개수 조회 (존재하면 1 이상, 없으면 0)
    int countByNickname(@Param("nickname") String nickname);

}
