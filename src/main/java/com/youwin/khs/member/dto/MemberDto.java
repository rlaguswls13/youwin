package com.youwin.khs.member.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Getter
@Setter
@ToString(exclude = "password")
@NoArgsConstructor
@AllArgsConstructor
public class MemberDto {
    private String memberId;
    private String memberPassword;
    private String nickname;
    private String memberPhone;
    private String memberEmail;
    private String profileImage;
    private String memberRole;
    private String memberStatus;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

