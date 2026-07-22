package com.youwin.controller;

import com.youwin.dto.LoginRequestDto;
import com.youwin.dto.MemberDto;
import com.youwin.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    @PostMapping("/login")
    public String login(LoginRequestDto loginDto, HttpSession session, RedirectAttributes rttr) {
        try {
            // 서비스 실행
            MemberDto loginUser = memberService.login(loginDto);
            session.setAttribute("loginUser", loginUser);
            return "redirect:/";

        } catch (IllegalArgumentException e) {
            // 서비스에서 예외가 발생하면 이쪽 catch 문으로 들어옴!
            // 화면에 보여줄 문구를 담아서 전달
            rttr.addFlashAttribute("errorMessage", e.getMessage());
            // 입력했던 아이디 값도 같이 전달
            rttr.addFlashAttribute("savedMemberId", loginDto.getMemberId());
            return "redirect:/member/login";
        }
    }

    // view 이동
    @GetMapping("/joinStep1")
    public String joinStep1() { return "member/joinStep1"; }

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

    @GetMapping("/settings")
    public String settingsForm() { return "member/settings"; }
}
