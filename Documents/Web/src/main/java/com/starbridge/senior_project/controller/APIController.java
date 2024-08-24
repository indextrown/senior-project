package com.starbridge.senior_project.controller;

import com.starbridge.senior_project.dto.ArtistScheduleDTO;
import com.starbridge.senior_project.service.ArtistScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class APIController {

    @Autowired
    private ArtistScheduleService artistScheduleService;

    /*
     * x_db 테이블에 저장된 모든 아티스트 스케줄을 반환
     * HTTP 메서드 : GET
     * HTTP 상태코드: 200 OK
     */
    @GetMapping("/api/schedules")
    @ResponseBody
    public ResponseEntity<List<ArtistScheduleDTO>> getSchedules(){
        List<ArtistScheduleDTO> artistScheduleDTOList = artistScheduleService.getAllSchedules();

        return ResponseEntity.ok(artistScheduleDTOList);
    }
}
