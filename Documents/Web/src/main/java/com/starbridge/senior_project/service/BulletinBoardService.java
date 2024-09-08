package com.starbridge.senior_project.service;

import com.starbridge.senior_project.dto.CreateBulletinBoardDTO;
import com.starbridge.senior_project.model.BulletinBoard;
import com.starbridge.senior_project.repository.BulletinBoardRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BulletinBoardService {

    @Autowired
    private BulletinBoardRepository bulletinBoardRepository;

    public BulletinBoard save(CreateBulletinBoardDTO createBulletinBoardDTO) {
        BulletinBoard bulletinBoard = new BulletinBoard(createBulletinBoardDTO);
        BulletinBoard savedBulletinBoard = bulletinBoardRepository.save(bulletinBoard);

        return savedBulletinBoard;
    }

    public List<BulletinBoard> findAll(){
        return bulletinBoardRepository.findAll();
    }

    public BulletinBoard findById(int number) {
        BulletinBoard bulletinBoard = bulletinBoardRepository.findById(number)
                .orElseThrow(() -> new IllegalArgumentException("not found: " + number));

        return bulletinBoard;
    }
}

// findById 예시
//public Article findById(long id) {
//    return blogRepository.findById(id)
//            .orElseThrow(() -> new IllegalArgumentException("not found : " + id));
//}