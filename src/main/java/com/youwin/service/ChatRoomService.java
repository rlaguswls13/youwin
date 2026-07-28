package com.youwin.service;


import com.youwin.dto.*;
import com.youwin.repository.ChatRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ChatRoomService {

    private final ChatRoomRepository repository;
    private Integer memberId;

    // ------------ 아티스트 -----------------
    public List<ArtistDto> findArtistList(){
        return repository.findArtistList();
    }

    public List<ArtistDto> searchArtist(String keyword){
        return repository.searchArtist(keyword);
    }

    public ArtistDto findArtist(Integer artistId) {
        return repository.findArtist(artistId);
    }

    // ----------------- 노래 ------------

    public List<SongDto> findSongList() {
        return repository.findSongList();
    }

    public List<SongDto> searchSong(String keyword){
        return repository.searchSong(keyword);
    }

    public List<SongDto> findSongByTheme(Integer themeId) {
        return repository.findSongByTheme(themeId);
    }

    public SongDto findSong(Integer songId) {
        return repository.findSong(songId);
    }

    // ----------------- 장르 ------------------
    public List<ThemeDto> findThemeList() {
        return repository.findThemeList();
    }

    public ThemeDto findTheme(Integer themeId){
        return repository.findTheme(themeId);
    }

    // ---------------------- 채팅방 ---------------------

    public List<ChatRoomDto> findRoomList(Integer memberId) {
        return repository.findRoomList(memberId);
    }

    public ChatRoomDto findRoom(Integer roomId) {
        return repository.findRoom(roomId);
    }

    public void createRoom(ChatRoomDto dto, Integer memberId){

        repository.createRoom(dto);

        ChatRoomMemberDto member = new ChatRoomMemberDto();
        member.setRoomId(dto.getRoomId());
        member.setMemberId(memberId);

        repository.joinRoom(member);
    }

    public boolean joinRoom(ChatRoomMemberDto dto){

        System.out.println("1");

        int count = repository.existsRoomMember(dto);

        System.out.println("count = " + count);

        if(count > 0){
            return false;
        }

        System.out.println("2");

        repository.joinRoom(dto);

        System.out.println("3");

        return true;
    }

    public void leaveRoom(ChatRoomMemberDto dto){
        repository.leaveRoom(dto);
        int count = repository.countMember(dto.getRoomId());

        if (count == 0) {

            repository.deleteRoom(dto.getRoomId());
    }
    }

    public boolean isJoined(Integer roomId, Integer memberId){

        return repository.isJoined(roomId, memberId);

    }

    public void updateRoom(ChatRoomDto dto){

        int result = repository.updateRoom(dto);

        if(result == 0){
            throw new RuntimeException("채팅방 수정 실패");
        }

    }

    public void deleteRoom(Integer roomId){ repository.deleteRoom(roomId);}

    // --------- 채팅 메시지 -----------

    public List<ChatMessageDto> findMessages(Integer roomId){
        return repository.findMessages(roomId);
    }

    public List<ChatMessageDto> findNewMessages(Integer roomId, Integer lastMessageId){
        return repository.findNewMessages(roomId, lastMessageId);
    }

    public ChatMessageDto saveMessage(ChatMessageDto dto){

        repository.saveMessage(dto);

        return repository.findMessage(dto.getMessageId());
    }



    // ----------------- 참여자 -----------------
    public List<ChatRoomMemberDto> findMembers(Integer roomId){
        return repository.findMembers(roomId);

    }

    // ------------- 현재 접속 중인 참여자 조회 -----------
    public List<ChatRoomMemberDto> findMembersByIds(List<Integer> memberIds){

        return repository.findMembersByIds(memberIds);

    }

}


