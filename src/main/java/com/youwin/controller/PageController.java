package com.youwin.controller;

import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
        public String chatroom(@RequestParam(defaultValue = "1") Integer roomId, Model model) {

            model.addAttribute("roomList", service.findRoomList());
            model.addAttribute("room", service.findRoom(roomId));
            model.addAttribute("messageList", service.findMessages(roomId));
            model.addAttribute("memberList", service.findMembers(roomId));

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
