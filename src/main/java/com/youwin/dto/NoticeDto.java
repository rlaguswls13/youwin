package com.youwin.dto;

import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class NoticeDto {
    private Long noticeId;
    private String memberId;
    private String category;
    private String title;
    private String content;
    private int count;
    private int isPinned;
    private LocalDateTime createAt;
    private LocalDateTime updateAt;
}
