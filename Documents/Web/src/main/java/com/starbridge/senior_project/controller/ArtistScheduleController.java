package com.starbridge.senior_project.controller;

import com.starbridge.senior_project.dto.ArtistScheduleDTO;
import com.starbridge.senior_project.service.ArtistScheduleService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class ArtistScheduleController {

    @Autowired
    private ArtistScheduleService artistScheduleService;

    @GetMapping("/artistSchedule")
    public String getAllSchedule(Model model, HttpSession session){
        //닉네임 세션에 값 추가해서 사용
        String nickname = (String) session.getAttribute("nickname");
        model.addAttribute("nickname", nickname);

        List<ArtistScheduleDTO> artistScheduleDTOList = artistScheduleService.getAllSchedules();
        model.addAttribute("artistSchedule", artistScheduleDTOList);
        return "artistSchedule";
    }


}
