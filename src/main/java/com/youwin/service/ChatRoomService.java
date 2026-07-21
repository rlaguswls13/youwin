package com.youwin.service;


import com.youwin.dto.ChatRoomDto;
import com.youwin.repository.ChatRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;

    public List<ChatRoomDto> findAllRooms() {
        return chatRoomRepository.findAllRooms();

    }
}
