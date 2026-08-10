package com.youwin.controller;

import com.youwin.api.ChatRoomSessiongManager;
import com.youwin.dto.ChatRoomMemberDto;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import com.youwin.dto.ChatMessageDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import com.youwin.repository.MemberRepository;
import java.security.Principal;

import java.util.List;

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

    @MessageMapping("/member/leave")
    public void leave(ChatRoomMemberDto dto, Principal principal) {

        if (principal == null) {
            return;
        }

        Integer memberId = memberRepository.findIdByMemberId(principal.getName());
        String loginId = principal.getName();

        Integer memberId = service.findMemberPkByLoginId(loginId);
        if (memberId == null) {
            return;
        }

        sessiongManager.leave(
                dto.getRoomId(),
                memberId
        );

        List<ChatRoomMemberDto> members = service.findMembers(dto.getRoomId());
        messagingTemplate.convertAndSend(
                "/topic/member/" + dto.getRoomId(),
                members
        );
    }
}