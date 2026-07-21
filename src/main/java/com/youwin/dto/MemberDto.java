package com.youwin.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString(exclude = "memberPassword")
@NoArgsConstructor
@AllArgsConstructor
public class MemberDto {
    private String memberId;
    private String memberPassword;
    private String nickname;
    private String memberEmail;
    private String memberPhone;
}
