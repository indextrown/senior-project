package com.donga.senior_project.controller;

import com.donga.senior_project.model.Data;
import com.donga.senior_project.repository.DataRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class DataController {

    @Autowired
    private DataRepository dataRepository;

    @GetMapping("/data")
    public String showData(Model model) {
        List<Data> dataList = dataRepository.findAll();
        model.addAttribute("dataList", dataList);
        return "data";
    }

    @GetMapping("/home")
    public String home(){
        return "home";
    }

    @GetMapping("/login")
    public String login(){
        return "login";
    }

    @GetMapping("/signup")
    public String signup(){
        return "signup";
    }
}
