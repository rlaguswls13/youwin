package com.youwin.api;

import com.youwin.dto.*;
import com.youwin.service.ChatMessageService;
import com.youwin.service.ChatRoomService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/chat")
public class ChatroomApiController {

    private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;

    // --------- 아티스트 목록 조회 --------------
    @GetMapping("/artist/list")
    public List<ArtistDto> findArtistList() {
        return chatRoomService.findArtistList();
    }

    // -------- 아티스트 검색 --------------
    @GetMapping("/artist/search")
    public List<ArtistDto> searchArtist(@RequestParam String keyword) {
        return chatRoomService.searchArtist(keyword);
    }

    @GetMapping("/artist/{artistId}/room")
    public List<ChatRoomDto> findRoomsByArtist(@PathVariable Integer artistId){
        return chatRoomService.findRoomsByArtist(artistId);
    }

    @GetMapping("/room/{roomId}/joined")
    @ResponseBody
    public boolean isJoined(@PathVariable Integer roomId) {

        Integer memberId = 1;   // 나중에 로그인 회원으로 변경

        return chatRoomService.isJoined(roomId, memberId);
    }

    // ---------- 노래 검색 --------------

    @GetMapping("/song/search")
    public List<SongDto> searchSong(@RequestParam String keyword) {
        return chatRoomService.searchSong(keyword);
    }

    @GetMapping("/song/{songId}/room")
    @ResponseBody
    public List<ChatRoomDto> findSongRoomList(@PathVariable Integer songId) {
        return chatRoomService.findRoomListBySong(songId);
    }



    // ----------- 노래 -------------

    @GetMapping("/song/list")
    public List<SongDto> findSongList() {
        return chatRoomService.findSongList();
    }

    // --------- 장르 ---------

     @GetMapping("/theme/list")
    public List<ThemeDto> findThemeList() {
        return chatRoomService.findThemeList();
    }

    @GetMapping("/theme/{themeId}")
    public ThemeDto findTheme(@PathVariable Integer themeId) {
        return chatRoomService.findTheme(themeId);
    }

    @GetMapping("/song/theme/{themeId}")
    public List<SongDto> findSongByTheme(@PathVariable Integer themeId) {return chatRoomService.findSongByTheme(themeId);}

    // --------- 채팅방 ---------

    @PostMapping("/room/create")
    public Integer createRoom(@RequestBody ChatRoomDto dto) {

        return chatRoomService.createRoom(dto);
    }

    @GetMapping("/room/list")
    public List<ChatRoomDto> findRoomList(HttpSession session) {

        Integer memberId = (Integer) session.getAttribute("loginMemberId");

        return chatRoomService.findRoomList(memberId);
    }

    @GetMapping("/room/{roomId}")
    public ChatRoomDto findRoom(@PathVariable Integer roomId) {
        return chatRoomService.findRoom(roomId);
    }

    @PostMapping("/room/update")
    public void updateRoom(@RequestBody ChatRoomDto dto) {

        chatRoomService.updateRoom(dto);
    }

    @PostMapping("/room/join")
    public Boolean joinRoom(@RequestBody ChatRoomMemberDto dto) {

        dto.setMemberId(1); // 테스트용

        return chatRoomService.joinRoom(dto);
    }

    @PostMapping("/room/leave")
    public void leaveRoom(@RequestBody ChatRoomMemberDto dto, HttpSession session) {

        Integer memberId = (Integer) session.getAttribute("loginMemberId");

        dto.setMemberId(memberId);

        chatRoomService.leaveRoom(dto);
    }

    // --------- 채팅 메시지 ---------

    @GetMapping("/message/{roomId}")
    public List<ChatMessageDto> findMessages(@PathVariable Integer roomId) {
        return chatRoomService.findMessages(roomId);
    }

    @GetMapping("/message/new")
    public List<ChatMessageDto> findNewMessages(
            @RequestParam Integer roomId,
            @RequestParam Integer lastMessageId) {

        return chatRoomService.findNewMessages(roomId, lastMessageId);
    }

    @PostMapping("/message/send")
    public void saveMessage(@RequestBody ChatMessageDto dto, HttpSession session) {

        Integer memberId =
                (Integer) session.getAttribute("loginMemberId");

        dto.setMemberId(memberId);

        chatRoomService.saveMessage(dto);
    }


    // --------- 참여자 ---------

    @GetMapping("/member/{roomId}")
    public List<ChatRoomMemberDto> findMembers(@PathVariable Integer roomId) {
        return chatRoomService.findMembers(roomId);
    }

}

