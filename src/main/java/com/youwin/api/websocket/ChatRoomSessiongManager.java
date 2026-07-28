package com.youwin.api.websocket;

import org.springframework.stereotype.Component;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatRoomSessiongManager {

    // roomId -> 접속중인 memberId 목록
    private final Map<Integer, Set<Integer>> roomMembers = new ConcurrentHashMap<>();

    // 입장
    public void join(Integer roomId, Integer memberId){

        roomMembers
                .computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet())
                .add(memberId);
    }

    // 퇴장
    public void leave(Integer roomId, Integer memberId) {

        Set<Integer> members = roomMembers.get(roomId);

        if(members == null) {
            return;
        }

        members.remove(memberId);

        if(members.isEmpty()){
            roomMembers.remove(roomId);
        }
    }

    // 현재 접속자
    public Set<Integer> getMembers(Integer roomId){
        return roomMembers.getOrDefault(roomId, Collections.emptySet());
    }

    // 현재 접속 인원
    public int count(Integer roomId){

        return getMembers(roomId).size();
    }
}
