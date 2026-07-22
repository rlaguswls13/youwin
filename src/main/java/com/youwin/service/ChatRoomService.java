package com.youwin.service;


import com.youwin.dto.ChatRoomDto;
import com.youwin.repository.ChatRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;

    public List<ChatRoomDto> findMyRooms(Integer memberId) {
        return chatRoomRepository.findMyRooms(memberId);
    }

    public Integer createRoom(ChatRoomDto dto, Integer memberId) {

        chatRoomRepository.createRoom(dto);

        chatRoomRepository.joinRoom(dto.getRoomId(), memberId);

        return dto.getRoomId();
    }
}
