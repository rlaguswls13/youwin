package com.youwin.controller;

import com.youwin.dto.ChatRoomDto;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import com.youwin.security.CustomUserDetails;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

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

    // 채팅방 만들기 화면
    @GetMapping("/room/create")
    public String createRoom() {
        return "createRoom";
    }

    // 채팅방 화면 (방장 및 신고 기능 연동 완료)
    @GetMapping("/chatroom")
    public String chatroom(
            @RequestParam(required = false) Integer roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails,
            HttpSession session,
            Model model) {

        if (userDetails == null) {
            return "redirect:/member/login";
        }

        String memberId = userDetails.getMemberDto().getMemberId();
        Integer memberPk = service.findMemberPkByLoginId(memberId);

        // roomId가 없으면 최근에 들어갔던 방 확인
        if (roomId == null) {

            Integer lastRoomId =
                    (Integer) session.getAttribute("lastRoomId");

            if (lastRoomId != null) {
                return "redirect:/chatroom?roomId=" + lastRoomId;
            }

            List<ChatRoomDto> rooms = service.findRoomList(memberPk);

            model.addAttribute("roomList", rooms);
            model.addAttribute("loginMemberId", memberPk);

            return "room/chatroom";
        }

        // 현재 방 기억
        session.setAttribute("lastRoomId", roomId);

        ChatRoomDto room = service.findRoom(roomId);

        model.addAttribute("roomList", service.findRoomList(memberPk));
        model.addAttribute("themeList", service.findThemeList());
        model.addAttribute("room", room);
        model.addAttribute("joined", service.isJoined(roomId, memberPk));
        model.addAttribute("loginMemberId", memberPk);
        model.addAttribute("messageList", service.findMessages(roomId));
        model.addAttribute("memberList", service.findMembers(roomId));
        boolean isOwner = room != null && memberPk.equals(room.getOwnerId());
        model.addAttribute("isOwner", isOwner);

        return "room/chatroom";
    }

    @GetMapping("/chatroom/details")
    public String details() {
        return "room/details";
    }

    @GetMapping("/artist")
    public String artist() {
        return "artist";
    }

    @GetMapping("/song")
    public String song() {
        return "song";
    }

    @GetMapping("/theme")
    public String theme() {
        return "theme";
    }
}