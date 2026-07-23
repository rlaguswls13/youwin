package com.youwin.dto;


import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ChatRoomDto {

    private Integer roomId;
    private String roomName;
    private Integer targetId;
    private Integer themeId;
    private LocalDateTime createdAt;
}
