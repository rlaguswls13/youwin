package com.youwin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/auth")
public class AuthController {

    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm() {
        return "auth/login";
    }

    // 아이디 찾기 페이지
    @GetMapping("/find-id")
    public String Form() {
        return "auth/find-id";
    }

    // 비밀번호 찾기 페이지
    @GetMapping("/find-password")
    public String findPasswordForm() {
        return "auth/find-password";
    }
}