package com.youwin.api;

import org.springframework.stereotype.Component;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatRoomSessiongManager {

    private final Map<Integer, Map<Integer, Integer>> roomMembers
            = new ConcurrentHashMap<>();

    private final Map<Integer, Map<Integer, Integer>> lastMessageMap
            = new ConcurrentHashMap<>();

    // 입장
    public void join(Integer roomId, Integer memberId, Integer lastMessageId) {

        Map<Integer, Integer> members =
                roomMembers.computeIfAbsent(
                        roomId,
                        k -> new ConcurrentHashMap<>()
                );

        // 같은 회원이 탭을 하나 더 열면 접속 개수 +1
        members.merge(memberId, 1, Integer::sum);

        lastMessageMap
                .computeIfAbsent(roomId, k -> new ConcurrentHashMap<>())
                .put(memberId, lastMessageId);
    }

    // 퇴장
    public void leave(Integer roomId, Integer memberId) {

        Map<Integer, Integer> members = roomMembers.get(roomId);

        if (members == null) {
            return;
        }

        Integer count = members.get(memberId);

        if (count == null) {
            return;
        }

        // 탭이 2개 이상이면 하나만 감소
        if (count > 1) {

            members.put(memberId, count - 1);

        } else {

            // 마지막 탭까지 닫혔을 때만 오프라인
            members.remove(memberId);

            Map<Integer, Integer> lastMap =
                    lastMessageMap.get(roomId);

            if (lastMap != null) {

                lastMap.remove(memberId);

                if (lastMap.isEmpty()) {
                    lastMessageMap.remove(roomId);
                }
            }
        }

        if (members.isEmpty()) {
            roomMembers.remove(roomId);
        }
    }

    // 현재 접속자
    public Set<Integer> getMembers(Integer roomId) {

        Map<Integer, Integer> members =
                roomMembers.get(roomId);

        if (members == null) {
            return Collections.emptySet();
        }

        return members.keySet();
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
