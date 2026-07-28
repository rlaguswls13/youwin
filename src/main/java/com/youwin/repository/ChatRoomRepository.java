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

    List<ChatRoomDto> findRoomList(Integer memberId);

    int countMember(Integer roomId);

    ChatRoomDto findRoom(Integer roomId);

    void createRoom(ChatRoomDto dto);

    void joinRoom(ChatRoomMemberDto dto);

    void leaveRoom(ChatRoomMemberDto dto);
    Integer existsRoomMember(ChatRoomMemberDto dto);

    void deleteRoom(Integer roomId);

    int updateRoom(ChatRoomDto dto);

    //----- 현재 사용자의 채팅방 가입 상태 조회 -------
    boolean isJoined(@Param("roomId") Integer roomId, @Param("memberId") Integer memberId);


    // --------- 채팅 메시지 -----------

    List<ChatMessageDto> findMessages(Integer roomId);

    List<ChatMessageDto> findNewMessages(@Param("roomId") Integer roomId, @Param("lastMessageId") Integer lastMessageId);

    void saveMessage(ChatMessageDto dto);

    String findNickname(Integer memberId);

    ChatMessageDto findMessage(Integer messageId);

    // ---------- 참여자 --------------

    List<ChatRoomMemberDto> findMembers(Integer roomId);

    // ---------- 현재 접속중인 참여자 -------------

    List<ChatRoomMemberDto> findMembersByIds(List<Integer> memberIds);
}
