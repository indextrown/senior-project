package com.starbridge.senior_project.service;

import com.starbridge.senior_project.dto.ArtistScheduleDTO;
import com.starbridge.senior_project.model.ArtistSchedule;
import com.starbridge.senior_project.repository.ArtistScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ArtistScheduleService {

    @Autowired
    private ArtistScheduleRepository artistScheduleRepository;

    public List<ArtistScheduleDTO> getAllSchedules() {
        List<ArtistSchedule> artistScheduleList = artistScheduleRepository.findAll();

        // List<Entity> -> List<DTO> 로 바꿔줘야 한다
        List<ArtistScheduleDTO> artistScheduleDTOList = artistScheduleList
                .stream()
                .map(ArtistScheduleDTO::new)
                .toList();

        return artistScheduleDTOList;
    }
}


