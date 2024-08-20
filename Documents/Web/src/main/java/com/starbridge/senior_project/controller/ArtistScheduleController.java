package com.starbridge.senior_project.controller;

import com.starbridge.senior_project.dto.ArtistScheduleDTO;
import com.starbridge.senior_project.model.ArtistSchedule;
import com.starbridge.senior_project.service.ArtistScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ArtistScheduleController {

    @Autowired
    private ArtistScheduleService artistScheduleService;

    @GetMapping("/artistSchedule")
    public String getAllSchedule(Model model){
        List<ArtistScheduleDTO> artistScheduleDTOList = artistScheduleService.getAllSchedules();
        model.addAttribute("artistSchedule", artistScheduleDTOList);
        return "artistSchedule";
    }

    @GetMapping("/schedules")
    @ResponseBody
    public List<ArtistScheduleDTO> getSchedules(){
        List<ArtistScheduleDTO> artistScheduleDTOList = artistScheduleService.getAllSchedules();
        return artistScheduleDTOList;

    }

}
