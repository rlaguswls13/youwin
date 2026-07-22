package com.youwin.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@ToString(exclude = "memberPassword") // 비밀번호 로그 출력 방지
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequestDto {
    private String memberId;
    private String memberPassword;
    private boolean autoLogin; // 자동 로그인 체크박스용 (선택사항)

}