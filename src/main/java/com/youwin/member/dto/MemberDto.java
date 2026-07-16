package com.youwin.member.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor; // 기본 생성자 생성
import lombok.AllArgsConstructor; //

@Getter
@Setter
@ToString(exclude = "password")
@NoArgsConstructor
@AllArgsConstructor
public class MemberDto {
    private String memberId;
    private String memberPassword;
    private String nickname;
    private String memberEmail;
    private String memberPhone;

}