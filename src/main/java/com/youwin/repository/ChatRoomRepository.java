package com.youwin.repository;

import com.youwin.dto.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface ChatRoomRepository {

    // --------- 아티스트 -------

    List<ArtistDto> findArtistList();

    List<ArtistDto> searchArtist(String keyword);


    // ---------- 노래 -------------

    List<SongDto> findSongList();

    List<SongDto> searchSong(String keyword);


    // -------------- 장르 ---------------

    List<ThemeDto> findThemeList();

    List<SongDto> findSongByTheme(Integer themeId);

    ThemeDto findTheme(Integer themeId);

    // -------------- 채팅방 -------------

    Integer findMemberPkByLoginId(String memberId);

    List<ChatRoomDto> searchChatRooms(String keyword);

    List<ChatRoomDto> findRoomList(Integer memberId);

    List<ChatRoomDto> findRoomListBySong(Integer songId);

    List<ChatRoomDto> findRoomsByArtist(Integer artistId);

    int countMember(Integer roomId);

    ChatRoomDto findRoom(Integer roomId);

    void createRoom(ChatRoomDto dto);

    void joinRoom(ChatRoomMemberDto dto);

    void leaveRoom(ChatRoomMemberDto dto);

    Integer existsRoomMember(ChatRoomMemberDto dto);

    void deleteRoom(Integer roomId);

    void deleteMessages(Integer roomId);

    void deleteRoomMembers(Integer roomId);

    List<ChatRoomDto> findRoomsByType(@Param("roomType") String roomType);

    int updateRoom(ChatRoomDto dto);

    Integer findMemberPkByMemberId(String memberId);


    //----- 현재 사용자의 채팅방 가입 상태 조회 -------

    boolean isJoined(@Param("roomId") Integer roomId, @Param("memberId") Integer memberId);



    // --------- 채팅 메시지 -----------

    List<ChatMessageDto> findMessages(Integer roomId);

    List<ChatMessageDto> findNewMessages(@Param("roomId") Integer roomId, @Param("lastMessageId") Integer lastMessageId);

    void saveMessage(ChatMessageDto dto);

    String findNickname(Integer memberId);

    ChatMessageDto findMessage(Integer messageId);

    Integer findLastMessageId(Integer roomId);


    // ---------- 참여자 --------------

    List<ChatRoomMemberDto> findMembers(Integer roomId);


    // ---------- 현재 접속중인 참여자 -------------

    List<ChatRoomMemberDto> findMembersByIds(List<Integer> memberIds);


    // ---------- 신고 ----------

    void saveReport(ChatReportDto dto);

    Integer findArtistIdByName(String artistName);

    Integer findSongIdByTitle(String songTitle);


    //  마지막으로 읽은 메시지 번호 저장
    void updateLastReadMessage(
            @Param("roomId") Integer roomId,
            @Param("memberId") Integer memberId,
            @Param("lastReadMessageId") Integer lastReadMessageId
    );

    // 마지막으로 읽은 메시지 번호 조회
    Integer findLastReadMessage(
            @Param("roomId") Integer roomId,
            @Param("memberId") Integer memberId
    );

    Integer countUnreadMember(

            @Param("roomId") Integer roomId,
            @Param("messageId") Integer messageId
    );
}
