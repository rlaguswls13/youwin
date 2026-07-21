package com.youwin.repository;

import com.youwin.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberRepository {
    int insertMember(MemberDto member);
}
