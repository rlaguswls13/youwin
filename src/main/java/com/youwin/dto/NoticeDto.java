package com.youwin.dto;

import java.time.LocalDateTime;
import java.util.List; // [추가] List 임포트
import org.springframework.web.multipart.MultipartFile; // [추가] MultipartFile 임포트
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

    // [신규 추가] 화면에서 첨부한 이미지 파일들을 받아낼 가방 (클래스 내부로 정상 진입)
    private List<MultipartFile> files;
}