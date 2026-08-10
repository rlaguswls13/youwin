package com.youwin.dto;


import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ChatReadStatusDto {

    private Integer roomId;
    private String memberId;
    private Long lastReadMessageId;
    private LocalDateTime updatedAt;
}
