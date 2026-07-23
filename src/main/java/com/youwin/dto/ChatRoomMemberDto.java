package com.youwin.dto;


import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ChatRoomMemberDto {

    private Integer roomId;
    private Integer memberId;
    private LocalDateTime joinAt;
}
