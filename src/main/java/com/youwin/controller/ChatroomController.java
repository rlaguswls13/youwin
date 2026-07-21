package com.youwin.controller;

import com.youwin.dto.ChatRoomDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller("chatroom")
@RequiredArgsConstructor
public class ChatroomController {

    private final ChatRoomService chatRoomService;

    @GetMapping("/chatroom")
    public String chatRoom(Model model){

        List<ChatRoomDto> roomList = chatRoomService.findAllRooms();

        model.addAttribute("roomList", roomList);

        return "room/chatroom";
    }

}
