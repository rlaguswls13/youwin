package com.youwin.controller;

import com.youwin.controller.dto.HomeMessage;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", HomeMessage.of("Youwin", "Spring Boot JSP application is ready."));
        return "index";


    }
}