package com.youwin.controller;

import com.youwin.api.websocket.ChatRoomSessiongManager;
import com.youwin.dto.ChatRoomMemberDto;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import com.youwin.dto.ChatMessageDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
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

    // 참여자 목록 갱신
    @MessageMapping("/memger")
    public void refreshMembers(ChatRoomMemberDto dto) {

        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getMemberId(),
                service.findMembers(dto.getMemberId())
        );
    }

    @MessageMapping("/member/join")
    public void join(ChatRoomMemberDto dto) {

        // 메모리에 접속자 등록
        sessiongManager.join(dto.getRoomId(), dto.getMemberId());

        // 접속중인 memberId 목록
        List<Integer> memberIds = new ArrayList<>(sessiongManager.getMembers(dto.getRoomId()));

        // 닉네임 조회
        List<ChatRoomMemberDto> members = service.findMembersByIds(memberIds);

        // 브라우저로 전송
        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getRoomId(),members
        );
    }

    @MessageMapping("/member/leave")
    public void leave(ChatRoomMemberDto dto) {

        // 메모리에서 제거
        sessiongManager.leave(dto.getRoomId(), dto.getMemberId());

        // 남아 있는 접속자 ID 목록
        List<Integer> memberIds = new ArrayList<>(sessiongManager.getMembers(dto.getRoomId()));

        // 닉네임 조회
        List<ChatRoomMemberDto> members = service.findMembersByIds(memberIds);

        // 모든 클라이언트에게 갱신된 목록 전송
        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getRoomId(),
                members
        );
    }
}