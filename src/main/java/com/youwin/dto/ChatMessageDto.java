package com.youwin.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ChatMessageDto {

    private Integer messageId;
    private Integer roomId;
    private Integer memberId;
    private String nickname;
    private String message;
    private LocalDateTime sentAt;
}
