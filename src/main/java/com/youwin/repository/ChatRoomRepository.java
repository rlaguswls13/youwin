package com.youwin.repository;

import com.youwin.dto.ChatRoomDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChatRoomRepository {

    List<ChatRoomDto> findAll();

    List<ChatRoomDto> findAllRooms();
}
