package com.youwin.controller;

import com.youwin.dto.MemberDto;
import com.youwin.service.MemberService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    @PostMapping("/join")
    public String registerProcess(
            @RequestParam String username,
            @RequestParam String password,
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String phone) {
        MemberDto memberDto = new MemberDto();
        memberDto.setMemberId(username);
        memberDto.setMemberPassword(password);
        memberDto.setNickname(name);
        memberDto.setMemberEmail(email);
        memberDto.setMemberPhone(phone);
        memberService.join(memberDto);
        return "redirect:/member/login";
    }

    @GetMapping("/join")
    public String joinForm() {
        return "member/join";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    @GetMapping("/index")
    public String mainForm() {
        return "redirect:/";
    }

    @GetMapping("/mypage")
    public String mypage() {
        return "member/mypage";
    }

    @GetMapping("/settings")
    public String settings() {
        return "member/settings";
    }
}
