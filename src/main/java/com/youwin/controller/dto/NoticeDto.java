package com.youwin.controller.dto;

import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
public class NoticeDto {
    private Long noticeId;       // board_id 계열 (BIGINT이므로 Long 추천)
    private String memberId;     // writer 대신 member_id
    private String category;
    private String title;
    private String content;
    private int count;           // views 대신 count
    private int isPinned;        // isTopFixed 대신 is_pinned
    private LocalDateTime createAt; // regDate 대신 create_at
    private LocalDateTime updateAt;
}