package com.youwin.dto;


import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatRoomMemberDto {

    private Integer roomId;
    private Integer memberId;
    private LocalDateTime joinAt;
}
