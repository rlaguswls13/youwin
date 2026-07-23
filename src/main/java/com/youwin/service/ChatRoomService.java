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

    public List<ChatRoomDto> findRoomList() {
        return repository.findRoomList();
    }

    public ChatRoomDto findRoom(Integer roomId) {
        return repository.findRoom(roomId);
    }

    public void createRoom(ChatRoomDto dto){

        repository.createRoom(dto);

        ChatRoomMemberDto member = new ChatRoomMemberDto();
        member.setRoomId(dto.getRoomId());
        member.setMemberId(1);

        repository.joinRoom(member);
    }

    public void joinRoom(ChatRoomMemberDto dto){
        repository.joinRoom(dto);
    }

    public void leaveRoom(ChatRoomMemberDto dto){
        repository.leaveRoom(dto);
    }

    // --------- 채팅 메시지 -----------

    public List<ChatMessageDto> findMessages(Integer roomId){
        return repository.findMessages(roomId);
    }

    public List<ChatMessageDto> findNewMessages(Integer roomId, Integer lastMessageId){
        return repository.findNewMessages(roomId, lastMessageId);
    }

    public void saveMessage(ChatMessageDto dto){
        repository.saveMessage(dto);
    }

    // ----------------- 참여자 -----------------
    public List<ChatRoomMemberDto> findMembers(Integer roomId){
        return repository.findMembers(roomId);
    }
}
