package com.youwin.dto;

import org.springframework.web.multipart.MultipartFile;
import java.time.LocalDateTime;
import java.util.List;

public class NoticeDto {
    private Long noticeId;
    private String category;
    private String title;
    private String content;
    private int isPinned;
    private int allowComments;
    private String memberId;
    private LocalDateTime createAt;
    private int count;

    // [중요] 뷰(JSP)에서 전송되는 이미지 파일 배열을 담기 위한 필드
    private MultipartFile[] files;

    // DB에서 조회한 이미지 목록을 담기 위한 필드
    private List<NoticeImageDto> imageList;

    // 기본 생성자
    public NoticeDto() {}

    // Getter & Setter
    public Long getNoticeId() { return noticeId; }
    public void setNoticeId(Long noticeId) { this.noticeId = noticeId; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getIsPinned() { return isPinned; }
    public void setIsPinned(int isPinned) { this.isPinned = isPinned; }

    public int getAllowComments() { return allowComments; }
    public void setAllowComments(int allowComments) { this.allowComments = allowComments; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public LocalDateTime getCreateAt() { return createAt; }
    public void setCreateAt(LocalDateTime createAt) { this.createAt = createAt; }

    public int getCount() { return count; }
    public void setCount(int count) { this.count = count; }

    public MultipartFile[] getFiles() { return files; }
    public void setFiles(MultipartFile[] files) { this.files = files; }

    public List<NoticeImageDto> getImageList() { return imageList; }
    public void setImageList(List<NoticeImageDto> imageList) { this.imageList = imageList; }
}