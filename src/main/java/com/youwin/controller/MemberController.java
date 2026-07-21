package com.youwin.controller;

import com.youwin.dto.MemberDto;
import com.youwin.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Controller
@RequestMapping("/member")
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/join")
    public String join(MemberDto memberDto, MultipartFile profile) {
        log.info("회원가입 요청 데이터: {}", memberDto);

        // INSERT 서비스 호출
        memberService.joinMember(memberDto);

        return "redirect:/member/login";
    }

    // view 이동
    @GetMapping("/joinStep1")
    public String joinStep1() {
        return "member/joinStep1";
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
