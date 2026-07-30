package com.youwin.controller;

import com.youwin.dto.*;
import com.youwin.service.ChatMessageService;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.ModelAndView;


import java.util.List;

@RequiredArgsConstructor
@Controller
public class ChatroomController {

    private final ChatRoomService service;


        // 전체 메인 페이지 화면
        @GetMapping("/")
        public String home() {
            return "index";
        }

        // 내 메인 페이지 화면
        @GetMapping("/index")
        public String index() {
            return "room/index";
        }

        //채팅방 만들기 화면
        @GetMapping("/room/create")
        public String createRoom() {
            return "createRoom";
        }

        // 채팅방 화면
        @GetMapping("/chatroom")
        public String chatroom(
                @RequestParam(required = false) Integer roomId, HttpSession session, Model model) {

            Integer memberId = (Integer) session.getAttribute("loginMemberId");

            if(memberId == null){
                memberId = 1;
                session.setAttribute("loginMemberId", memberId);
            }

            if (roomId == null) {

                List<ChatRoomDto> rooms = service.findRoomList(memberId);

                model.addAttribute("roomList", rooms);

                return "room/chatroom";

            }

            model.addAttribute("roomList", service.findRoomList(memberId));
           // model.addAttribute("themeList", service.findThemeList());
            model.addAttribute("room", service.findRoom(roomId));
            model.addAttribute("joined", service.isJoined(roomId, memberId));
            model.addAttribute("loginMemberId", memberId);
            model.addAttribute("messageList", List.of());
            model.addAttribute("memberList", service.findMembers(roomId));

            return "room/chatroom";
        }

        @GetMapping("/chatroom/details")
        public String details() {
            return "room/details";
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


