package com.youwin.khs.member.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/member/join")
public class Step1Controller extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 케밥 케이스 name값 그대로 꺼내기
        String memberId = request.getParameter("member-id");
        String memberPassword = request.getParameter("member-password");
        String memberName = request.getParameter("member-name");
        String nickname = request.getParameter("nickname");
        String memberEmail = request.getParameter("member-email");
        String memberPhone = request.getParameter("member-phone");

        // 세션에 저장
        HttpSession session = request.getSession();
        session.setAttribute("step1_memberId", memberId);
        session.setAttribute("step1_memberPassword", memberPassword);
        session.setAttribute("step1_memberName", memberName);
        session.setAttribute("step1_nickname", nickname);
        session.setAttribute("step1_memberEmail", memberEmail);
        session.setAttribute("step1_memberPhone", memberPhone);

        // step2.jsp로 이동
        request.getRequestDispatcher("/WEB-INF/views/member/step2.jsp").forward(request, response);
    }
}