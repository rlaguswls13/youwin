package com.youwin.repository;

import com.youwin.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberRepository {
    int save(MemberDto member);

    int countById(@Param("memberId") String memberId);
}
