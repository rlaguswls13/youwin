package com.youwin.mapper;

import com.youwin.controller.dto.NoticeDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface NoticeMapper {
    List<NoticeDto> selectNoticeList(); // 기존 조회 메서드

    // 💡 [추가] 공지사항을 등록하는 메서드
    int insertNotice(NoticeDto noticeDto);
}