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
    private String message;
    private String sentAt;
    private String nickname;
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
}
