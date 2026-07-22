package com.youwin.controller;

import com.youwin.dto.ChatMessageDto;
import com.youwin.dto.ChatRoomDto;
import com.youwin.service.ChatMessageService;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@Controller
public class ChatroomController {

    private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;

    @GetMapping("/chatroom")
    public String chatRoom(@RequestParam(defaultValue = "1") Integer roomId, Model model) {

        Integer memberId = 1;

        model.addAttribute("roomList", chatRoomService.findMyRooms(memberId)
        );

        model.addAttribute("messageList", chatMessageService.findMessages(roomId)
        );

        return "room/chatroom";
    }

    @PostMapping("/chatroom/message")
    @ResponseBody
    public void saveMessage(@RequestBody ChatMessageDto dto) {

        chatMessageService.saveMessage(dto);

    }

    @PostMapping("/chatroom/create")
    @ResponseBody
    public Integer createRoom(@RequestBody ChatRoomDto dto) {

        Integer memberId = 1;

        return chatRoomService.createRoom(dto, memberId);
    }
}