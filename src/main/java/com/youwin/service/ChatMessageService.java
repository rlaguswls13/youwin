package com.youwin.service;

import com.youwin.dto.ChatMessageDto;
import com.youwin.repository.ChatMessageRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;

    public List<ChatMessageDto> findMessages(Integer roomId){

        return chatMessageRepository.findMessages(roomId);

    }

    public void saveMessage(ChatMessageDto dto){
        chatMessageRepository.saveMessage(dto);
    }

}