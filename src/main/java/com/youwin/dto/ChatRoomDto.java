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
    private String roomDescription;
    private String roomType;

    private String artistName;
    private String songTitle;
    private Integer targetId;
    private Integer themeId;

    private String roomImageUrl;
    private String ownerName;
    private Integer ownerId;
    private Integer memberCount;
    private LocalDateTime createdAt;




}
