package com.youwin.api;

import com.youwin.dto.*;
import com.youwin.repository.MemberRepository;
import com.youwin.service.ChatMessageService;
import com.youwin.service.ChatRoomService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import com.youwin.security.CustomUserDetails;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.http.ResponseEntity;


@RequiredArgsConstructor
@RestController
@RequestMapping("/chat")
public class ChatroomApiController {

    private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;
    private final MemberRepository memberRepository;

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
    public boolean isJoined(
            @PathVariable Integer roomId,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId = userDetails.getMemberDto().getMemberId();

        Integer memberId = chatRoomService.findMemberPkByLoginId(loginId);

        return chatRoomService.isJoined(
                roomId,
                memberId
        );
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
    @GetMapping("/room/search")
    public List<ChatRoomDto> searchChatRooms(@RequestParam String keyword) {
        return chatRoomService.searchChatRooms(keyword);
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
    public ResponseEntity<?> createRoom(
            @RequestPart("room") ChatRoomDto dto,
            @RequestPart(value = "image", required = false) MultipartFile image,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        // 로그인 아이디
        String loginId = userDetails.getMemberDto().getMemberId();

        // 로그인 아이디 → 실제 member 테이블 PK
        Integer memberId =
                memberRepository.findIdByMemberId(loginId);

        Integer roomId =
                chatRoomService.createRoom(
                        dto,
                        image,
                        memberId
                );

        return ResponseEntity.ok(roomId);
    }

    @GetMapping("/room/list")
    public List<ChatRoomDto> findRoomList(
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId = userDetails.getMemberDto().getMemberId();
        Integer memberId = chatRoomService.findMemberPkByLoginId(loginId);

        return chatRoomService.findRoomList(memberId);
    }

    @GetMapping("/room/{roomId}")
    public ChatRoomDto findRoom(@PathVariable Integer roomId) {
        return chatRoomService.findRoom(roomId);
    }

    @PostMapping("/room/update")
    public void updateRoom(
            @RequestBody ChatRoomDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId =
                userDetails.getMemberDto().getMemberId();

        Integer memberId =
                chatRoomService.findMemberPkByLoginId(loginId);

        chatRoomService.updateRoom(dto, memberId);
    }

    @PostMapping("/room/join")
    public Boolean joinRoom(
            @RequestBody ChatRoomMemberDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId = userDetails.getMemberDto().getMemberId();
        Integer memberId = chatRoomService.findMemberPkByLoginId(loginId);

        dto.setMemberId(memberId);

        return chatRoomService.joinRoom(dto);
    }

    @GetMapping("/room/type/{roomType}")
    public List<ChatRoomDto> findRoomsByType(@PathVariable String roomType) {
        return chatRoomService.findRoomsByType(roomType);
    }

    @PostMapping("/room/leave")
    public void leaveRoom(
            @RequestBody ChatRoomMemberDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId = userDetails.getMemberDto().getMemberId();
        Integer memberId = chatRoomService.findMemberPkByLoginId(loginId);

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
    public void saveMessage(
            @RequestBody ChatMessageDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId = userDetails.getMemberDto().getMemberId();
        Integer memberId = chatRoomService.findMemberPkByLoginId(loginId);

        dto.setMemberId(memberId);

        chatRoomService.saveMessage(dto);
    }


    // --------- 참여자 ---------

    @GetMapping("/member/{roomId}")
    public List<ChatRoomMemberDto> findMembers(@PathVariable Integer roomId) {
        return chatRoomService.findMembers(roomId);
    }

    @PostMapping("/report")
    public void reportMember(
            @RequestBody ChatReportDto dto,
            @AuthenticationPrincipal CustomUserDetails userDetails) {

        String loginId = userDetails.getMemberDto().getMemberId();
        Integer memberId = chatRoomService.findMemberPkByLoginId(loginId);

        chatRoomService.saveReport(
                dto,
                memberId
        );
    }

}

