package com.youwin.repository;

import com.youwin.dto.NoticeDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface NoticeRepository {
    List<NoticeDto> findAll();

    int save(NoticeDto notice);
}
