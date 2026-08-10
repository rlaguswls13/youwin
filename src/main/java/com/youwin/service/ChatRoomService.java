package com.youwin.service;

import com.youwin.api.ChatRoomSessiongManager;
import com.youwin.dto.*;
import com.youwin.repository.ChatRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;
    private final ChatRoomSessiongManager sessiongManager;
    private final SimpMessagingTemplate messagingTemplate;

    // ------------ 아티스트 -----------------
    public List<ArtistDto> findArtistList(){
        return chatRoomRepository.findArtistList();
    }

    public List<ArtistDto> searchArtist(String keyword){
        return chatRoomRepository.searchArtist(keyword);
    }

    public List<ChatRoomDto> findRoomsByArtist(Integer artistId) {
        return chatRoomRepository.findRoomsByArtist(artistId);
    }

    public List<ChatRoomDto> findRoomListBySong(Integer songId) {
        return chatRoomRepository.findRoomListBySong(songId);
    }

    public List<ChatRoomDto> searchChatRooms(String keyword) {
        return chatRoomRepository.searchChatRooms(keyword);
    }

    // ----------------- 노래 ------------

    public List<SongDto> findSongList() {
        return chatRoomRepository.findSongList();
    }

    public List<SongDto> searchSong(String keyword){
        return chatRoomRepository.searchSong(keyword);
    }

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

    public Integer findMemberPkByLoginId(String memberId) {
        Integer memberPk = chatRoomRepository.findMemberPkByLoginId(memberId);
        if (memberPk == null) {
            throw new IllegalArgumentException("로그인 회원 정보를 찾을 수 없습니다.");
        }
        return memberPk;
    }

    public List<ChatRoomDto> findRoomList(Integer memberId) {
        return chatRoomRepository.findRoomList(memberId);
    }

    public ChatRoomDto findRoom(Integer roomId) {
        return chatRoomRepository.findRoom(roomId);
    }

    @Transactional
    public Integer createRoom(
            ChatRoomDto dto,
            MultipartFile image,
            Integer loginMemberId) {

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
        } else {
            String defaultImage = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='150' height='150' viewBox='0 0 150 150'><rect width='100%' height='100%' fill='%23cccccc'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-family='sans-serif' font-size='14' fill='%23333333'>No Image</text></svg>";
            dto.setRoomImageUrl(defaultImage);
        }

        dto.setOwnerId(loginMemberId);

        dto.setTargetId(null);

        chatRoomRepository.createRoom(dto);

        ChatRoomMemberDto memberDto = new ChatRoomMemberDto();
        memberDto.setRoomId(dto.getRoomId());
        memberDto.setMemberId(loginMemberId);

        chatRoomRepository.joinRoom(memberDto);

        return dto.getRoomId();
    }

    public boolean joinRoom(ChatRoomMemberDto dto){
        int count = chatRoomRepository.existsRoomMember(dto);
        if(count > 0){
            return false;
        }
        chatRoomRepository.joinRoom(dto);
        return true;
    }

    @Transactional
    public void leaveRoom(ChatRoomMemberDto dto){

        sessiongManager.leave(dto.getRoomId(), dto.getMemberId());


        chatRoomRepository.leaveRoom(dto);

        int count = chatRoomRepository.countMember(dto.getRoomId());

        if(count == 0){

            chatRoomRepository.deleteMessages(dto.getRoomId());
            chatRoomRepository.deleteRoom(dto.getRoomId());
            chatRoomRepository.deleteRoomMembers(dto.getRoomId());

            messagingTemplate.convertAndSend("/topic/room/delete/" + dto.getRoomId(), dto.getRoomId());

        } else {

            List<ChatRoomMemberDto> members = findMembers(dto.getRoomId());
            messagingTemplate.convertAndSend("/topic/member/" + dto.getRoomId(), members);
        }
    }

    public boolean isJoined(Integer roomId, Integer memberId){
        return chatRoomRepository.isJoined(roomId, memberId);
    }

    @Transactional
    public void updateRoom(ChatRoomDto dto, MultipartFile image, Integer memberId) {
        ChatRoomDto room = chatRoomRepository.findRoom(dto.getRoomId());
        if (room == null) {
            throw new RuntimeException("채팅방이 존재하지 않습니다.");
        }
        if (!memberId.equals(room.getOwnerId())) {
            throw new RuntimeException("방장만 채팅방을 수정할 수 있습니다.");
        }

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
        } else {
            dto.setRoomImageUrl(room.getRoomImageUrl());
        }

        dto.setOwnerId(memberId);
        int result = chatRoomRepository.updateRoom(dto);
        if (result == 0) {
            throw new RuntimeException("채팅방 수정 실패");
        }
    }

    public void deleteRoom(Integer roomId){
        chatRoomRepository.deleteRoom(roomId);
    }

    // --------- 채팅 메시지 -----------

    public List<ChatMessageDto> findMessages(Integer roomId){
        List<ChatMessageDto> list = chatRoomRepository.findMessages(roomId);
        for(ChatMessageDto message : list){
            Integer unread = chatRoomRepository.countUnreadMember(roomId, message.getMessageId());
            message.setUnreadCount(unread);
        }
        return list;
    }

    public Integer countUnreadMember(Integer roomId, Integer messageId){
        return chatRoomRepository.countUnreadMember(roomId, messageId);
    }

    public Integer findLastMessageId(Integer roomId){
        return chatRoomRepository.findLastMessageId(roomId);
    }

    public List<ChatMessageDto> findNewMessages(Integer roomId, Integer lastMessageId){
        List<ChatMessageDto> list = chatRoomRepository.findNewMessages(roomId, lastMessageId);
        for(ChatMessageDto message : list){
            Integer unread = chatRoomRepository.countUnreadMember(roomId, message.getMessageId());
            message.setUnreadCount(unread);
        }
        return list;
    }

    public ChatMessageDto saveMessage(ChatMessageDto dto){
        // 1. DB 저장
        chatRoomRepository.saveMessage(dto);

        // 2. 저장된 메시지 조회
        ChatMessageDto result = chatRoomRepository.findMessage(dto.getMessageId());

        // 3. 보낸 사람은 읽은 것으로 처리
        chatRoomRepository.updateLastReadMessage(
                result.getRoomId(),
                result.getMemberId(),
                result.getMessageId()
        );

        // 4. 읽지 않은 사람 수 계산
        Integer unread = chatRoomRepository.countUnreadMember(
                result.getRoomId(),
                result.getMessageId()
        );

        result.setUnreadCount(unread);
        return result;
    }

    // 마지막 읽은 메시지 저장
    public void updateLastReadMessage(Integer roomId, Integer memberId, Integer lastReadMessageId){
        chatRoomRepository.updateLastReadMessage(roomId, memberId, lastReadMessageId);

        List<ChatMessageDto> messages = chatRoomRepository.findMessages(roomId);
        List<ChatMessageDto> updatedList = new ArrayList<>();

        for(ChatMessageDto message : messages){
            Integer unread = chatRoomRepository.countUnreadMember(roomId, message.getMessageId());
            message.setUnreadCount(unread);
            updatedList.add(message);
        }

        messagingTemplate.convertAndSend("/topic/read/" + roomId, updatedList);
    }

    // 마지막 읽은 메시지 조회
    public Integer findLastReadMessage(Integer roomId, Integer memberId) {
        Integer lastRead = chatRoomRepository.findLastReadMessage(roomId, memberId);
        if(lastRead == null) {
            return 0;
        }
        return lastRead;
    }

    public List<ChatRoomDto> findRoomsByType(String roomType) {
        return chatRoomRepository.findRoomsByType(roomType);
    }

    // ----------------- 참여자 -----------------
    public List<ChatRoomMemberDto> findMembers(Integer roomId){
        List<ChatRoomMemberDto> members = chatRoomRepository.findMembers(roomId);
        Set<Integer> onlineIds = sessiongManager.getMembers(roomId);
        List<ChatRoomMemberDto> onlineMembers = List.of();

        if (!onlineIds.isEmpty()) {
            onlineMembers = chatRoomRepository.findMembersByIds(List.copyOf(onlineIds));
        }

        for(ChatRoomMemberDto member : members){
            member.setOnline(onlineIds.contains(member.getMemberId()));
        }

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

        ChatRoomDto room = chatRoomRepository.findRoom(roomId);
        if (room != null && room.getOwnerId() != null) {
            members.sort((member1, member2) -> {
                boolean member1Owner = member1.getMemberId().equals(room.getOwnerId());
                boolean member2Owner = member2.getMemberId().equals(room.getOwnerId());

                if (member1Owner && !member2Owner) {return -1;}
                if (!member1Owner && member2Owner) {return 1;}
                return 0;
            });
        }
        return members;
    }

    public List<ChatRoomMemberDto> findMembersByIds(List<Integer> memberIds){
        return chatRoomRepository.findMembersByIds(memberIds);
    }

    public void joinRoom(Integer roomId, Integer memberId) {
        ChatRoomMemberDto dto = new ChatRoomMemberDto();
        dto.setRoomId(roomId);
        dto.setMemberId(memberId);
        chatRoomRepository.joinRoom(dto);
    }

    public void saveReport(ChatReportDto dto, Integer loginMemberId) {
        if (loginMemberId.equals(dto.getReportedId())) {
            throw new IllegalArgumentException("자기 자신은 신고할 수 없습니다.");
        }

        boolean joined = chatRoomRepository.isJoined(dto.getRoomId(), loginMemberId);
        if (!joined) {
            throw new IllegalArgumentException("채팅방 참여자만 신고할 수 있습니다.");
        }

        dto.setReporterId(loginMemberId);
        chatRoomRepository.saveReport(dto);
    }
}