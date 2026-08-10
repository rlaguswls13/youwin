package com.youwin.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class NoticeImageDto {
    private Long imageId;          // 이미지 고유 식별 번호 (PK)
    private Long noticeId;         // 해당 이미지가 속한 공지사항 번호 (FK)
    private String originalName;   // 사용자가 업로드한 원본 파일명
    private String savedFileName;  // 서버에 안전하게 저장된 고유 파일명 (UUID 적용)
    private LocalDateTime regDate; // 이미지 업로드 등록 일시

    // 필수 값(noticeId, originalName, savedFileName)을 한 번에 초기화할 수 있는 오버로딩 생성자 유지
    public NoticeImageDto(Long noticeId, String originalName, String savedFileName) {
        this.noticeId = noticeId;
        this.originalName = originalName;
        this.savedFileName = savedFileName;
    }
}