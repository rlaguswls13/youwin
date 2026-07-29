package com.youwin.controller;

import com.youwin.dto.ChatRoomDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@RequiredArgsConstructor
@Controller
public class PageController {

    private final ChatRoomService service;

    // 메인 페이지
    @GetMapping("/")
    public String index() {
        return "index";
    }

    // 채팅방 목록
    @GetMapping("/room")
    public String room() {
        return "room";
    }

    // 채팅 화면
    @GetMapping("/chatroom")
    public String chatroom(
            @RequestParam(required = false) Integer roomId,
            @RequestParam(defaultValue = "1") Integer memberId,
            Model model) {

        if (roomId == null) {

            List<ChatRoomDto> rooms = service.findRoomList(memberId);

            if (rooms.isEmpty()) {
                model.addAttribute("roomList", rooms);
                return "room/chatroom";
            }

            return "redirect:/chatroom?roomId=" + rooms.get(0).getRoomId() + "&memberId=" + memberId;
        }

        List<ChatRoomDto> roomList = service.findRoomList(memberId);

        model.addAttribute("roomList", roomList);
        model.addAttribute("themeList", service.findThemeList());

        ChatRoomDto room = service.findRoom(roomId);

        model.addAttribute("room", room);

        if(room != null){

            model.addAttribute("joined", service.isJoined(roomId, memberId));

            model.addAttribute("loginMemberId", memberId);

            model.addAttribute("messageList", List.of());

            model.addAttribute("memberList",
                    service.findMembers(roomId));

        }else{

            model.addAttribute("joined", false);

            model.addAttribute("loginMemberId", memberId);

            model.addAttribute("messageList", List.of());

            model.addAttribute("memberList", List.of());

        }

        return "room/chatroom";
    }

        // 아티스트
        @GetMapping("/artist")
        public String artist() {
            return "artist";
        }

        // 노래
        @GetMapping("/song")
        public String song() {
            return "song";
        }

        // 장르
        @GetMapping("/theme")
        public String theme() {
            return "theme";
        }

    }
