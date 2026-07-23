package com.youwin.controller;

import com.youwin.dto.*;
import com.youwin.service.ChatMessageService;
import com.youwin.service.ChatRoomService;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/chat")
public class ChatroomController {

    private final ChatRoomService service;
    private final ChatMessageService chatMessageService;

    // --------- 아티스트 --------------

    @GetMapping("/artist/list")
    public List<ArtistDto> findArtistList() {
        return service.findArtistList();
    }

    @GetMapping("/artist/search")
    public List<ArtistDto> searchArtist(@RequestParam String keyword) {
        return service.searchArtist(keyword);
    }

    @GetMapping("/artist/{artistId}")
    public ArtistDto findArtist(@PathVariable Integer artistId) {
        return service.findArtist(artistId);
    }

    // --------- 노래 ---------

    @GetMapping("/song/list")
    public List<SongDto> findSongList() {
        return service.findSongList();
    }

    @GetMapping("/song/search")
    public List<SongDto> searchSong(@RequestParam String keyword) {
        return service.searchSong(keyword);
    }

    @GetMapping("/song/theme/{themeId}")
    public List<SongDto> findSongByTheme(@PathVariable Integer themeId) {
        return service.findSongByTheme(themeId);
    }

    @GetMapping("/song/{songId}")
    public SongDto findSong(@PathVariable Integer songId) {
        return service.findSong(songId);
    }

    // --------- 장르 ---------

    @GetMapping("/theme/list")
    public List<ThemeDto> findThemeList() {
        return service.findThemeList();
    }

    @GetMapping("/theme/{themeId}")
    public ThemeDto findTheme(@PathVariable Integer themeId) {
        return service.findTheme(themeId);
    }

    // --------- 채팅방 ---------

    @GetMapping("/room/list")
    public List<ChatRoomDto> findRoomList() {
        return service.findRoomList();
    }

    @GetMapping("/room/{roomId}")
    public ChatRoomDto findRoom(@PathVariable Integer roomId) {
        return service.findRoom(roomId);
    }

    @PostMapping("/room/create")
    public Integer createRoom(@RequestBody ChatRoomDto dto) {

        service.createRoom(dto);

        return dto.getRoomId();
    }

    @PostMapping("/room/join")
    public void joinRoom(@RequestBody ChatRoomMemberDto dto) {
        service.joinRoom(dto);
    }

    @PostMapping("/room/leave")
    public void leaveRoom(@RequestBody ChatRoomMemberDto dto) {
        service.leaveRoom(dto);
    }

    // --------- 채팅 메시지 ---------

    @GetMapping("/message/{roomId}")
    public List<ChatMessageDto> findMessages(@PathVariable Integer roomId) {
        return service.findMessages(roomId);
    }

    @GetMapping("/message/new")
    public List<ChatMessageDto> findNewMessages(
            @RequestParam Integer roomId,
            @RequestParam Integer lastMessageId) {

        return service.findNewMessages(roomId, lastMessageId);
    }

    @PostMapping("/message/send")
    public void saveMessage(@RequestBody ChatMessageDto dto) {
        service.saveMessage(dto);
    }

    // --------- 참여자 ---------

    @GetMapping("/member/{roomId}")
    public List<ChatRoomMemberDto> findMembers(@PathVariable Integer roomId) {
        return service.findMembers(roomId);
    }

}
