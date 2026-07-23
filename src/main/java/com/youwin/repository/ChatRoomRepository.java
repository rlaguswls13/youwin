package com.youwin.repository;

import com.youwin.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ChatRoomRepository {

     // --------- 아티스트 -------
    List<ArtistDto> findArtistList();

    List<ArtistDto> searchArtist(@Param("keyword") String keyword);

    ArtistDto findArtist(Integer artistId);

    // ---------- 노래 -------------

    List<SongDto> findSongList();

    List<SongDto> searchSong(@Param("keyword") String keyword);

    List<SongDto> findSongByTheme(Integer themeId);

    SongDto findSong(Integer songId);

    // -------------- 장르 ---------------

    List<ThemeDto> findThemeList();

    ThemeDto findTheme(Integer themeId);

    // -------------- 채팅방 -------------

    List<ChatRoomDto> findRoomList();

    ChatRoomDto findRoom(Integer roomId);

    void createRoom(ChatRoomDto dto);

    void joinRoom(ChatRoomMemberDto dto);

    void leaveRoom(ChatRoomMemberDto dto);

    // --------- 채팅 메시지 -----------

    List<ChatMessageDto> findMessages(Integer roomId);

    List<ChatMessageDto> findNewMessages(@Param("roomId") Integer roomId,
                                         @Param("lastMessageId") Integer lastMessageId);

    void saveMessage(ChatMessageDto dto);

    // ---------- 참여자 --------------

    List<ChatRoomMemberDto> findMembers(Integer roomId);
}
