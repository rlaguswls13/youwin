package com.youwin.repository;

import com.youwin.dto.ChatRoomDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatRoomRepository {

    List<ChatRoomDto> findMyRooms(@Param("memberId") Integer memberId);
}

