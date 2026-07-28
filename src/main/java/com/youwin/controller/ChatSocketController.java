package com.youwin.controller;

import com.youwin.dto.ChatRoomMemberDto;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import com.youwin.dto.ChatMessageDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class ChatSocketController {

    private final ChatRoomService service;
    private final SimpMessagingTemplate messagingTemplate;

    // 메시지 전송
    @MessageMapping("/message")
    public void send(ChatMessageDto dto) {

        ChatMessageDto result = service.saveMessage(dto);

        messagingTemplate.convertAndSend(
                "/topic/chat/" + result.getRoomId(),
                result
        );
    }

    // 참여자 목록 갱신
    @MessageMapping("/memger")
    public void refreshMembers(ChatRoomMemberDto dto) {

        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getMemberId(),
                service.findMembers(dto.getMemberId())
        );
    }
}
