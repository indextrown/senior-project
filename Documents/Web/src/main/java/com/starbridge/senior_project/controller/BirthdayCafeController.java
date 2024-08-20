package com.starbridge.senior_project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BirthdayCafeController {

    @GetMapping("/birthdayCafe")
    public String birthCafe(){
        return "birthdayCafe";
    }
}
