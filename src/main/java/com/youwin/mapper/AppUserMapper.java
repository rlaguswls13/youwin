package com.youwin.mapper;

import com.youwin.mapper.dto.AppUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface AppUserMapper {

    List<AppUser> findAll();

    @Select("SELECT COUNT(*) FROM app_user")
    long count();
}