package com.youwin.controller;

import com.youwin.api.ChatRoomSessiongManager;
import com.youwin.dto.ChatMessageDto;
import com.youwin.dto.ChatRoomMemberDto;
import com.youwin.repository.MemberRepository;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ChatSocketController {

    private final ChatRoomService service;
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatRoomSessiongManager sessiongManager;
    private final MemberRepository memberRepository;

    /**
     * 1. 메시지 전송
     */
    @MessageMapping("/message")
    public void send(ChatMessageDto dto) {
        ChatMessageDto result = service.saveMessage(dto);

        messagingTemplate.convertAndSend(
                "/topic/chat/" + result.getRoomId(),
                result
        );
    }

    /**
     * 2. 멤버 입장
     */
    @MessageMapping("/member/join")
    public void join(ChatRoomMemberDto dto, Principal principal) {
        if (principal == null) {
            return;
        }

        String loginId = principal.getName();
        Integer memberId = memberRepository.findIdByMemberId(loginId);

        if (memberId == null) {
            return;
        }

        Integer lastMessageId = service.findLastMessageId(dto.getRoomId());
        sessiongManager.join(
                dto.getRoomId(),
                memberId,
                lastMessageId
        );

        List<ChatRoomMemberDto> members = service.findMembers(dto.getRoomId());
        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getRoomId(),
                members
        );
    }

    /**
     * 3. 멤버 퇴장
     */
    @MessageMapping("/member/leave")
    public void leave(ChatRoomMemberDto dto, Principal principal) {
        if (principal == null) {
            return;
        }

        Integer memberId = memberRepository.findIdByMemberId(principal.getName());
        if (memberId == null) {
            return;
        }

        sessiongManager.leave(dto.getRoomId(), memberId);

        List<ChatRoomMemberDto> members = service.findMembers(dto.getRoomId());
        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getRoomId(),
                members
        );
    }

    /**
     * 4. 메시지 읽음 처리
     */
    @MessageMapping("/message/read")
    public void read(Map<String, Object> payload, Principal principal) {
        if (principal == null) {
            return;
        }

        Integer memberId = memberRepository.findIdByMemberId(principal.getName());
        if (memberId == null) {
            return;
        }

        Integer roomId = Integer.valueOf(payload.get("roomId").toString());
        Integer lastReadMessageId = Integer.valueOf(payload.get("lastReadMessageId").toString());

        service.updateLastReadMessage(
                roomId,
                memberId,
                lastReadMessageId
        );
    }
}