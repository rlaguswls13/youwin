package com.youwin.api;

import org.springframework.stereotype.Component;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatRoomSessiongManager {

    private final Map<Integer, Map<Integer, Integer>> roomMembers =
            new ConcurrentHashMap<>();

    private final Map<Integer, Map<Integer, Integer>> lastMessageMap =
            new ConcurrentHashMap<>();

    // WebSocket 세션별 접속 정보
    private final Map<String, SessionInfo> sessions =
            new ConcurrentHashMap<>();



    // 채팅방 입장

    public void join(
            Integer roomId,
            Integer memberId,
            Integer lastMessageId,
            String sessionId
    ) {

        Map<Integer, Integer> members =
                roomMembers.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>());

        // 같은 회원이 여러 탭을 열면 접속 횟수 증가
        members.merge(memberId, 1, Integer::sum);

        // 마지막 읽은 메시지 저장
        lastMessageMap
                .computeIfAbsent(roomId, k -> new ConcurrentHashMap<>())
                .put(memberId, lastMessageId);

        // 현재 WebSocket 세션 정보 저장
        sessions.put(sessionId, new SessionInfo(roomId, memberId)
        );
    }



    // 명시적인 채팅방 나가기

    public void leave(
            Integer roomId,
            Integer memberId
    ) {

        // 해당 회원의 세션 하나를 찾아 제거
        String targetSessionId = null;

        for (Map.Entry<String, SessionInfo> entry : sessions.entrySet()) {

            SessionInfo info = entry.getValue();

            if (info.roomId.equals(roomId)
                    && info.memberId.equals(memberId)) {

                targetSessionId = entry.getKey();
                break;
            }
        }

        if (targetSessionId != null) {
            leaveBySession(targetSessionId);
        }
    }



    // WebSocket 연결 종료

    public SessionInfo leaveBySession(String sessionId) {

        SessionInfo info = sessions.remove(sessionId);

        if (info == null) {
            return null;
        }

        Integer roomId = info.roomId;
        Integer memberId = info.memberId;

        Map<Integer, Integer> members = roomMembers.get(roomId);

        if (members == null) {return info;}

        Integer count = members.get(memberId);

        if (count == null) {return info;}

        // 같은 회원의 다른 탭이 남아있으면
        // 접속 횟수만 감소
        if (count > 1) {

            members.put(memberId, count - 1);

        } else {

            // 마지막 탭이면 완전히 오프라인 처리
            members.remove(memberId);

            Map<Integer, Integer> lastMap = lastMessageMap.get(roomId);

            if (lastMap != null) {

                lastMap.remove(memberId);

                if (lastMap.isEmpty()) {
                    lastMessageMap.remove(roomId);
                }
            }
        }

        // 채팅방에 접속자가 없으면
        // 해당 방의 메모리 정보 제거
        if (members.isEmpty()) {roomMembers.remove(roomId);}

        return info;
    }



    // 현재 접속자 조회

    public Set<Integer> getMembers(Integer roomId) {

        Map<Integer, Integer> members = roomMembers.get(roomId);

        if (members == null) {return Collections.emptySet();}

        return members.keySet();
    }



    // 현재 접속 인원

    public int count(Integer roomId) {
        return getMembers(roomId).size();
    }



    // 마지막 읽은 메시지 조회

    public Integer getLastMessageId(Integer roomId, Integer memberId) {

        Map<Integer, Integer> map = lastMessageMap.get(roomId);

        if (map == null) {return 0;}

        return map.getOrDefault(memberId, 0);
    }



    // WebSocket 세션 정보

    public static class SessionInfo {

        private final Integer roomId;
        private final Integer memberId;

        public SessionInfo(Integer roomId, Integer memberId) {
            this.roomId = roomId;
            this.memberId = memberId;
        }

        public Integer getRoomId() {return roomId;}

        public Integer getMemberId() {return memberId;}
    }
}