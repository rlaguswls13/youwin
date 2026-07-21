package com.youwin.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ChatMessageDto {

    private Integer messageId;
    private Integer roomId;
    private Integer memberId;
    private String message;
    private LocalDateTime sentAt;
}
