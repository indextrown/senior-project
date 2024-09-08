package com.starbridge.senior_project.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class BirthdayCafeController {

    @Autowired
    private BirthdayCafeService birthdayCafeService;

    @GetMapping("/birthdayCafe")
    public String birthCafe(Model model, HttpSession session) {
        //닉네임 세션에 값 추가해서 사용
        String nickname = (String) session.getAttribute("nickname");
        model.addAttribute("nickname", nickname);

        List<BirthdayCafeDTO> birthdayCafeDTOList = birthdayCafeService.getAllCafe();
        model.addAttribute("cafes", birthdayCafeDTOList);

        return "birthdayCafe";
    }
}
