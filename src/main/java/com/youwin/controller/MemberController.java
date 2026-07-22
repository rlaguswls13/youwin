package com.youwin.controller;

import com.youwin.dto.MemberDto;
import com.youwin.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/join")
    public String join(MemberDto memberDto, MultipartFile profile) {
        // INSERT 서비스 호출
        memberService.joinMember(memberDto);

        return "redirect:/member/login";
    }

    // view 이동
    @GetMapping("/joinStep1")
    public String joinStep1() {
        return "member/joinStep1";
    }

    @GetMapping("/joinStep2")
    public String joinStep2() {
        return "member/joinStep2";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    @GetMapping("/mypage")
    public String mypageForm() {
        return "member/mypage";
    }
}
