package com.youwin.api.websocket;

import org.springframework.stereotype.Component;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatRoomSessiongManager {

    private final Map<Integer, Set<Integer>> roomMembers
            = new ConcurrentHashMap<>();

    private final Map<Integer, Map<Integer, Integer>> lastMessageMap
            = new ConcurrentHashMap<>();

    // 입장
    public void join(Integer roomId, Integer memberId, Integer lastMessageId) {

        roomMembers
                .computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet())
                .add(memberId);

        lastMessageMap
                .computeIfAbsent(roomId, k -> new ConcurrentHashMap<>())
                .put(memberId, lastMessageId);

    }

    // 퇴장
    public void leave(Integer roomId, Integer memberId) {

        Set<Integer> members = roomMembers.get(roomId);

        if (members == null) {
            return;
        }

        members.remove(memberId);

        if (members.isEmpty()) {
            roomMembers.remove(roomId);
        }

        Map<Integer, Integer> lastMap = lastMessageMap.get(roomId);

        if (lastMap != null) {

            lastMap.remove(memberId);

            if (lastMap.isEmpty()) {
                lastMessageMap.remove(roomId);
            }
        }
    }

    // 현재 접속자
    public Set<Integer> getMembers(Integer roomId) {
        return roomMembers
                .getOrDefault(roomId, Collections.emptySet());
    }

    // 현재 접속 인원
    public int count(Integer roomId) {

        return getMembers(roomId).size();
    }

    public Integer getLastMessageId(Integer roomId, Integer memberId) {

        Map<Integer, Integer> map =
                lastMessageMap.get(roomId);

        if (map == null) {
            return 0;
        }

        return map.getOrDefault(memberId, 0);

    }
}
