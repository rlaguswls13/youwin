package com.youwin.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.AllArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

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

    private MultipartFile profile;
}

