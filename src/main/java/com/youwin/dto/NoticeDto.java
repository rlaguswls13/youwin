package com.youwin.dto;

import java.time.LocalDateTime;
import java.util.List;
import org.springframework.web.multipart.MultipartFile;
import lombok.Getter;
import lombok.Setter;

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

    // 새로 업로드하는 이미지 파일들 (가방)
    private List<MultipartFile> files;

    // 수정 시 유지할 기존 이미지 파일명/URL 목록
    private List<String> existingFiles;
}