package com.starbridge.senior_project.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/main")
    public String main(Model model, HttpSession session){
        //닉네임 세션에 값 추가해서 사용
        String nickname = (String) session.getAttribute("nickname");
        model.addAttribute("nickname", nickname);

        return "main";
    }
}
