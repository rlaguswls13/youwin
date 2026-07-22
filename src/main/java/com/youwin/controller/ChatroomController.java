package com.youwin.controller;

import com.youwin.dto.ChatRoomDto;
import com.youwin.service.ChatMessageService;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@RequiredArgsConstructor
@Controller
public class ChatroomController {

    private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;

    @GetMapping("/chatroom")
    public String chatRoom(Model model) {

        Integer memberId = 1;
        Integer roomId = 1;

        model.addAttribute(
                "roomList",
                chatRoomService.findMyRooms(memberId)
        );

        model.addAttribute(
                "messageList",
                chatMessageService.findMessages(roomId)
        );

        return "room/chatroom";
    }
}