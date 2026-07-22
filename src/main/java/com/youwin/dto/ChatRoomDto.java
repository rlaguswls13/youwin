package com.youwin.dto;


import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatRoomDto {

    private Integer roomId;
    private String roomName;
    private Integer targetId;
    private Integer themeId;
    private LocalDateTime createdAt;
}
