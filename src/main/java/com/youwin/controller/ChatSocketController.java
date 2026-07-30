package com.youwin.controller;

import com.youwin.api.ChatRoomSessiongManager;
import com.youwin.dto.ChatRoomMemberDto;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import com.youwin.dto.ChatMessageDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ChatSocketController {

    private final ChatRoomService service;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatRoomSessiongManager sessiongManager;

    // 메시지 전송
    @MessageMapping("/message")
    public void send(ChatMessageDto dto) {

        ChatMessageDto result = service.saveMessage(dto);

        messagingTemplate.convertAndSend(
                "/topic/chat/" + result.getRoomId(),
                result
        );
    }

    @MessageMapping("/member/join")
    public void join(ChatRoomMemberDto dto) {

        Integer lastMessageId = service.findLastMessageId(dto.getRoomId());

        // 메모리에 접속자 등록
        sessiongManager.join(dto.getRoomId(), dto.getMemberId(), lastMessageId);

        List<ChatRoomMemberDto> members = service.findMembers(dto.getRoomId());

        messagingTemplate.convertAndSend(
               "/topic/member/" + dto.getRoomId(),
               members
       );
    }

    @MessageMapping("/member/leave")
    public void leave(ChatRoomMemberDto dto) {


        System.out.println("===== LEAVE =====");
        System.out.println(dto);

        // 메모리에서 제거
        sessiongManager.leave(dto.getRoomId(), dto.getMemberId());

       List<ChatRoomMemberDto> members = service.findMembers(dto.getRoomId());

       messagingTemplate.convertAndSend(
               "/topic/member/" + dto.getRoomId(),
               members
       );
    }
}