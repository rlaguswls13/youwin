package com.youwin.service;


import com.youwin.api.ChatRoomSessiongManager;
import com.youwin.dto.*;
import com.youwin.repository.ChatRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Transactional
public class ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;
    private final ChatRoomSessiongManager sessiongManager;

    // ------------ 아티스트 -----------------
    public List<ArtistDto> findArtistList(){
        return chatRoomRepository.findArtistList();
    }  // v

    public List<ArtistDto> searchArtist(String keyword){
        return chatRoomRepository.searchArtist(keyword);
    } // v

    public List<ChatRoomDto> findRoomsByArtist(Integer artistId) {
        return chatRoomRepository. findRoomsByArtist(artistId);
    } //v

    public List<ChatRoomDto> findRoomListBySong(Integer songId) {
        return chatRoomRepository.findRoomListBySong(songId);
    } //v

    public List<ChatRoomDto> searchChatRooms(String keyword) {
        return chatRoomRepository.searchChatRooms(keyword);
    }

    // ----------------- 노래 ------------

    public List<SongDto> findSongList() {
        return chatRoomRepository.findSongList();
    }

    public List<SongDto> searchSong(String keyword){
        return chatRoomRepository.searchSong(keyword);
    } // v

    public List<SongDto> findSongByTheme(Integer themeId) {
        return chatRoomRepository.findSongByTheme(themeId);
    }

    // ----------------- 장르 ------------------
    public List<ThemeDto> findThemeList() {
        return chatRoomRepository.findThemeList();
    }

    public ThemeDto findTheme(Integer themeId){
        return chatRoomRepository.findTheme(themeId);
    }

    // ---------------------- 채팅방 ---------------------

    public List<ChatRoomDto> findRoomList(Integer memberId) {
        return chatRoomRepository.findRoomList(memberId);
    }

    public ChatRoomDto findRoom(Integer roomId) {
        return chatRoomRepository.findRoom(roomId);
    }

    public Integer createRoom(ChatRoomDto dto, MultipartFile image) {

        if (image != null && !image.isEmpty()) {

            String fileName = UUID.randomUUID() + "_" + image.getOriginalFilename();
            String uploadPath = "D:/project/youwin/upload/chatroom/";

            File dir = new File(uploadPath);

            if (!dir.exists()) {
                dir.mkdirs();
            }

            try {
                image.transferTo(new File(dir, fileName));
                dto.setRoomImageUrl("/upload/chatroom/" + fileName);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        // 채팅방 생성
        chatRoomRepository.createRoom(dto);

        // 생성자를 채팅방에 자동 참여
        ChatRoomMemberDto memberDto = new ChatRoomMemberDto();
        memberDto.setRoomId(dto.getRoomId());
        memberDto.setMemberId(1); // 테스트용
        chatRoomRepository.joinRoom(memberDto);

        return dto.getRoomId();
    }

    public boolean joinRoom(ChatRoomMemberDto dto){

        int count = chatRoomRepository.existsRoomMember(dto);

        System.out.println("exists = " + count);

        if(count > 0){
            return false;
        }

        chatRoomRepository.joinRoom(dto);

        return true;
    }

    public void leaveRoom(ChatRoomMemberDto dto){

        chatRoomRepository.leaveRoom(dto);

        int count = chatRoomRepository.countMember(dto.getRoomId());

        if(count == 0){

            chatRoomRepository.deleteMessages(dto.getRoomId());
            chatRoomRepository.deleteRoom(dto.getRoomId());

        }
    }

    public boolean isJoined(Integer roomId, Integer memberId){

        return chatRoomRepository.isJoined(roomId, memberId);

    }

    public void updateRoom(ChatRoomDto dto){

        int result = chatRoomRepository.updateRoom(dto);

        if(result == 0){
            throw new RuntimeException("채팅방 수정 실패");
        }

    }

    public void deleteRoom(Integer roomId){ chatRoomRepository.deleteRoom(roomId);}

    // --------- 채팅 메시지 -----------

    public List<ChatMessageDto> findMessages(Integer roomId){
        return chatRoomRepository.findMessages(roomId);
    }


    public Integer findLastMessageId(Integer roomId){
        return chatRoomRepository.findLastMessageId(roomId);
    }

    public List<ChatMessageDto> findNewMessages(Integer roomId, Integer lastMessageId){
        return chatRoomRepository.findNewMessages(roomId, lastMessageId);
    }

    public ChatMessageDto saveMessage(ChatMessageDto dto){

        chatRoomRepository.saveMessage(dto);

        return chatRoomRepository.findMessage(dto.getMessageId());
    }



    // ----------------- 참여자 -----------------
    public List<ChatRoomMemberDto> findMembers(Integer roomId){

        // 가입자(DB)
        List<ChatRoomMemberDto> members =
                chatRoomRepository.findMembers(roomId);

        // 현재 접속자(메모리)
        Set<Integer> onlineIds =
                sessiongManager.getMembers(roomId);

        // 접속한 회원 정보
        List<ChatRoomMemberDto> onlineMembers = List.of();

        if (!onlineIds.isEmpty()) {

            onlineMembers =
                    chatRoomRepository.findMembersByIds(
                            List.copyOf(onlineIds)
                    );

        }

        // 가입자의 온라인 여부
        for(ChatRoomMemberDto member : members){

            member.setOnline(
                    onlineIds.contains(member.getMemberId())
            );

        }

        // 가입 안 했는데 접속한 사람 추가
        for(ChatRoomMemberDto online : onlineMembers){

            boolean exists = false;

            for(ChatRoomMemberDto member : members){

                if(member.getMemberId().equals(online.getMemberId())){

                    exists = true;
                    break;

                }

            }

            if(!exists){

                online.setRoomId(roomId);

                online.setOnline(true);

                members.add(online);

            }

        }

        return members;

    }

    // ------------- 현재 접속 중인 참여자 조회 -----------
    public List<ChatRoomMemberDto> findMembersByIds(List<Integer> memberIds){

        return chatRoomRepository.findMembersByIds(memberIds);

    }

    public void joinRoom(Integer roomId, Integer memberId) {

        ChatRoomMemberDto dto = new ChatRoomMemberDto();

        dto.setRoomId(roomId);
        dto.setMemberId(memberId);

        chatRoomRepository.joinRoom(dto);
    }
}


