package com.starbridge.senior_project.service;

import com.starbridge.senior_project.dto.BirthdayCafeDTO;
import com.starbridge.senior_project.model.BirthdayCafe;
import com.starbridge.senior_project.repository.BirthdayCafeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BirthdayCafeService {

    @Autowired
    private BirthdayCafeRepository birthdayCafeRepository;

    public List<BirthdayCafeDTO> getAllCafe(){
        List<BirthdayCafe> birthdayCafeList = birthdayCafeRepository.findAll();

        // List<Entity> -> List<DTO>로 바꿔서 반환하기
        List<BirthdayCafeDTO> birthdayCafeDTOList = birthdayCafeList
                .stream()
                .map(BirthdayCafeDTO::new)
                .toList();

        return birthdayCafeDTOList;

    }

}