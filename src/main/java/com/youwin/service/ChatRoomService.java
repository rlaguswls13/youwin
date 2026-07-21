package com.youwin.service;


import com.youwin.dto.ChatRoomDto;
import com.youwin.repository.ChatRoomRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;

    public ChatRoomService(ChatRoomRepository chatRoomRepository) {
        this.chatRoomRepository = chatRoomRepository;

        }
    public static List<ChatRoomDto> findAllRooms() {
        return chatRoomRepository.findAllRooms();

    }
}
