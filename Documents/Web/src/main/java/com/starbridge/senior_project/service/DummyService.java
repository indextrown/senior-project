package com.starbridge.senior_project.service;

import com.starbridge.senior_project.repository.DummyRepository;
import org.springframework.stereotype.Service;
import com.starbridge.senior_project.model.Dummy;

import java.util.List;

@Service
public class DummyService {

    private final DummyRepository dummyRepository;

    public DummyService(DummyRepository dummyRepository) {
        this.dummyRepository = dummyRepository;
    }

    public List<Dummy> getAllDummies() {
        return dummyRepository.findAll();
    }
}