package com.youwin.dto;

import java.time.LocalDateTime;

/**
 * 공지사항에 첨부되는 이미지 정보를 담는 DTO 클래스
 */
public class NoticeImageDto {

    private Long imageId;          // 이미지 고유 식별 번호 (PK)
    private Long noticeId;         // 해당 이미지가 속한 공지사항 번호 (FK)
    private String originalName;   // 사용자가 업로드한 원본 파일명
    private String savedFileName;  // 서버에 중복 방지용으로 안전하게 저장된 고유 파일명 (UUID 적용)
    private LocalDateTime regDate; // 이미지 업로드 등록 일시

    // 기본 생성자
    public NoticeImageDto() {}

    // 필수 값을 초기화하는 생성자
    public NoticeImageDto(Long noticeId, String originalName, String savedFileName) {
        this.noticeId = noticeId;
        this.originalName = originalName;
        this.savedFileName = savedFileName;
    }

    // Getter & Setter 메서드들
    public Long getImageId() {
        return imageId;
    }

    public void setImageId(Long imageId) {
        this.imageId = imageId;
    }

    public Long getNoticeId() {
        return noticeId;
    }

    public void setNoticeId(Long noticeId) {
        this.noticeId = noticeId;
    }

    public String getOriginalName() {
        return originalName;
    }

    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }

    public String getSavedFileName() {
        return savedFileName;
    }

    public void setSavedFileName(String savedFileName) {
        this.savedFileName = savedFileName;
    }

    public LocalDateTime getRegDate() {
        return regDate;
    }

    public void setRegDate(LocalDateTime regDate) {
        this.regDate = regDate;
    }
}