package com.youwin.dto;

import lombok.*;
import org.springframework.web.multipart.MultipartFile;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class NoticeDto {
    private Long noticeId;
    private String memberId;      // 작성자 아이디
    private String category;      // 카테고리
    private String title;         // 제목
    private String content;       // 내용
    private LocalDateTime createAt; // 작성일시

    // JSTL 또는 화면 포맷팅용 문자열 필드 (필요 시 활용)
    private String createAtStr;

    // 공지사항 상단 고정 여부 (0: 일반, 1: 고정)
    private int isPinned;

    // 댓글 허용 여부 (0: 비허용, 1: 허용)
    private int allowComments;

    // 조회수 필드
    private int count;

    // 뷰(JSP)에서 전송되는 업로드 이미지 파일 배열
    private MultipartFile[] files;

    // 상세 보기 화면 등에서 보여줄 첨부 이미지 목록 (일대다 관계 매핑)
    private List<NoticeImageDto> imageList;
}