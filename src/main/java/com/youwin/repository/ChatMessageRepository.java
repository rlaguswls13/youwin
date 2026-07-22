package com.youwin.repository;

import com.youwin.dto.ChatMessageDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ChatMessageRepository {

    List<ChatMessageDto> findMessages(Integer roomId);

    void saveMessage(ChatMessageDto dto);
}