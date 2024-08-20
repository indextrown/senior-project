//package com.starbridge.senior_project.service;
//
//import com.starbridge.senior_project.model.ArtistEvent;
//import com.starbridge.senior_project.repository.ArtistEventRepository;
//import org.springframework.stereotype.Service;
//
//import java.util.List;
//
//@Service
//public class ArtistEventService {
//
//    private final ArtistEventRepository artistEventRepository;
//
//    public ArtistEventService(ArtistEventRepository artistEventRepository){
//        this.artistEventRepository = artistEventRepository;
//    }
//
//    public List<ArtistEvent> getAllEvents() {
//        return artistEventRepository.findAll();
//    }
//
//}