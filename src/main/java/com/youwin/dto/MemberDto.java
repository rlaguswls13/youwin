package com.youwin.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.AllArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Getter
@Setter
@ToString(exclude = "memberPassword")
@NoArgsConstructor
@AllArgsConstructor
public class MemberDto {
    // JSP input태그의 name 속성과 일치해야 자동으로 바인딩됩니다.
    private String memberId;
    private String memberPassword;
    private String memberName;
    private String memberEmail;
    private String memberPhone;
    private String nickname;
    private String profileImage;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private MultipartFile profile;

    // JSP에서 ${member.formattedCreatedAt} 으로 부를 때 사용되는 메서드
    public String getFormattedCreatedAt() {
        if (this.createdAt == null) return "";
        return this.createdAt.format(DateTimeFormatter.ofPattern("yyyy.MM.dd"));
    }

    // JSP에서 ${member.formattedUpdatedAt} 으로 부를 때 사용되는 메서드
    public String getFormattedUpdatedAt() {
        if (this.updatedAt == null) return "";
        return this.updatedAt.format(DateTimeFormatter.ofPattern("yyyy.MM.dd"));
    }
}

