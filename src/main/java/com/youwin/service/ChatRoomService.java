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

    public Integer findMemberPkByLoginId(String memberId) {

        Integer memberPk = chatRoomRepository.findMemberPkByLoginId(memberId);

        if (memberPk == null) {
            throw new IllegalArgumentException(
                    "로그인 회원 정보를 찾을 수 없습니다."
            );
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

        // =========================
        // 1. 이미지 저장
        // =========================
        if (image != null && !image.isEmpty()) {

            String fileName = UUID.randomUUID() + "_" + image.getOriginalFilename();

            String uploadPath = System.getProperty("user.dir") + "/upload/chatroom/";

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


        // =========================
        // 2. 로그인 회원을 방장으로 설정
        // =========================
        dto.setOwnerId(loginMemberId);


        // =========================
        // 3. 입력한 아티스트/노래로 targetId 찾기
        // =========================
        if ("artist".equals(dto.getRoomType())) {

            Integer artistId = chatRoomRepository.findArtistIdByName(
                    dto.getArtistName()
                    );

            if (artistId == null) {
                throw new IllegalArgumentException("등록되어 있지 않은 아티스트입니다.");
            }
            dto.setTargetId(artistId);

        } else if ("song".equals(dto.getRoomType())) {

            Integer songId =
                    chatRoomRepository.findSongIdByTitle(dto.getSongTitle());

            if (songId == null) {
                throw new IllegalArgumentException("등록되어 있지 않은 노래입니다.");
            }
            dto.setTargetId(songId);
        } else {
            throw new IllegalArgumentException("잘못된 채팅방 종류입니다.");
        }

        // =========================
        // 4. 채팅방 생성
        // =========================
        chatRoomRepository.createRoom(dto);

        // =========================
        // 5. 방장을 참여자로 자동 가입
        // =========================
        ChatRoomMemberDto memberDto = new ChatRoomMemberDto();

        memberDto.setRoomId(dto.getRoomId());
        memberDto.setMemberId(loginMemberId);

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

    @Transactional
    public void updateRoom(ChatRoomDto dto, MultipartFile image, Integer memberId) {

        // 1. 수정하려는 채팅방 조회
        ChatRoomDto room = chatRoomRepository.findRoom(dto.getRoomId());

        if (room == null) {
            throw new RuntimeException("채팅방이 존재하지 않습니다.");
        }

        // 2. 현재 로그인 회원이 방장인지 확인
        if (!memberId.equals(room.getOwnerId())) {
            throw new RuntimeException("방장만 채팅방을 수정할 수 있습니다.");
        }

        // 3. 새 이미지가 있으면 이미지 변경
        if (image != null && !image.isEmpty()) {

            String fileName = UUID.randomUUID() + "_" + image.getOriginalFilename();
            String uploadPath = System.getProperty("user.dir") + "/upload/chatroom/";
            File dir = new File(uploadPath);

            if (!dir.exists()) {
                dir.mkdirs();
            }

            try {

                image.transferTo(new File(dir, fileName)
                );

                dto.setRoomImageUrl("/upload/chatroom/" + fileName
                );

            } catch (IOException e) {
                throw new RuntimeException(e);
            }

        } else {

            // 새 이미지가 없으면 기존 이미지 유지
            dto.setRoomImageUrl(room.getRoomImageUrl()
            );
        }

        // 4. UPDATE에 사용할 실제 방장 PK
        dto.setOwnerId(memberId);

        // 5. 수정
        int result =
                chatRoomRepository.updateRoom(dto);

        if (result == 0) {
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

    public List<ChatRoomDto> findRoomsByType(String roomType) {
        return chatRoomRepository.findRoomsByType(roomType);
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

    public void saveReport(
            ChatReportDto dto,
            Integer loginMemberId) {

        if (loginMemberId.equals(dto.getReportedId())) {
            throw new IllegalArgumentException("자기 자신은 신고할 수 없습니다.");
        }

        boolean joined =
                chatRoomRepository.isJoined(
                        dto.getRoomId(),
                        loginMemberId
                );

        if (!joined) {
            throw new IllegalArgumentException("채팅방 참여자만 신고할 수 있습니다.");
        }

        dto.setReporterId(loginMemberId);
        chatRoomRepository.saveReport(dto);
    }
}


