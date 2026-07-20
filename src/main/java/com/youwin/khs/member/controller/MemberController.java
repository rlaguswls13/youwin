package com.youwin.khs.member.controller;

import com.youwin.khs.member.dto.MemberDto;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member")
public class MemberController {
    // 2. 가입 처리하기 (POST)
    @PostMapping("/join")
    public String registerProcess(MemberDto memberdto) {
        // [여기에 들어갈 로직]
        // 1. 비밀번호 암호화하기 (Spring Security의 PasswordEncoder 권장)
        // 2. 이메일 중복 체크하기
        // 3. DB에 저장하기 (MyBatis나 JPA 사용)

        System.out.println("가입 시도한 이메일: " + memberdto.getMemberEmail());
        System.out.println("가입 시도한 닉네임: " + memberdto.getNickname());

        return "redirect:/member/settings";
    }

    // view 이동
    @GetMapping("/join")
    public String joinFrom() {
        return "member/join";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    @GetMapping("/index")
    public String mainForm() {
        return "member/index";
    }

    @GetMapping("/settings")
    public String settingsForm() {
        return "member/settings";
    }

    @GetMapping("/mypage")
    public String mypageForm() {
        return "member/mypage";
    }
}
