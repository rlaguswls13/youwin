package com.youwin.controller;

import com.youwin.api.ChatRoomSessiongManager;
import com.youwin.dto.ChatRoomMemberDto;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import com.youwin.dto.ChatMessageDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import java.security.Principal;
import java.security.Principal;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.context.event.EventListener;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class ChatSocketController {

    private final ChatRoomService service;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatRoomSessiongManager sessiongManager;

    /**
     * 1. 메시지 전송
     */

    // 메시지 전송
    @MessageMapping("/message")
    public void send(ChatMessageDto dto) {

        ChatMessageDto result = service.saveMessage(dto);

        messagingTemplate.convertAndSend("/topic/chat/" + result.getRoomId(), result);
    }

    @MessageMapping("/member/join")
    public void join(ChatRoomMemberDto dto, Principal principal, StompHeaderAccessor accessor) {

        if (principal == null) {return;}

        String loginId = principal.getName();

        Integer memberId = service.findMemberPkByLoginId(loginId);

        if (memberId == null) {return;}

        Integer lastMessageId = service.findLastMessageId(dto.getRoomId());

        String sessionId = accessor.getSessionId();

        sessiongManager.join(dto.getRoomId(), memberId, lastMessageId, sessionId
        );

        List<ChatRoomMemberDto> members = service.findMembers(dto.getRoomId());

        messagingTemplate.convertAndSend("/topic/member/" + dto.getRoomId(), members
        );
    }

    // 메시지 읽음 처리
    @MessageMapping("/message/read")
    public void readMessage(ChatRoomMemberDto dto, Principal principal) {

        if (principal == null) {return;}

        Integer memberId = service.findMemberPkByLoginId(principal.getName());

        if (memberId == null) {return;}

        service.updateLastReadMessage(dto.getRoomId(), memberId, dto.getLastReadMessageId()
        );
    }

    @EventListener
    public void handleDisconnect(SessionDisconnectEvent event) {

        String sessionId = StompHeaderAccessor
                        .wrap(event.getMessage())
                        .getSessionId();

        if (sessionId == null) {return;}

        ChatRoomSessiongManager.SessionInfo info = sessiongManager.leaveBySession(sessionId);

        if (info == null) {return;}

        Integer roomId = info.getRoomId();

        List<ChatRoomMemberDto> members = service.findMembers(roomId);

        messagingTemplate.convertAndSend("/topic/member/" + roomId, members);
    }
}