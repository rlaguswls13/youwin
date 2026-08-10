package com.youwin.dto;


import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ChatHistoryDto {

    private Long messageId;
    private Integer roomId;
    private String senderId;
    private String nickname;
    private String messageContent;
    private LocalDateTime createdAt;
    private int unreadCount;


}
