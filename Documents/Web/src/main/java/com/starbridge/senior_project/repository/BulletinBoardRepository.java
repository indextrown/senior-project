package com.starbridge.senior_project.repository;

import com.starbridge.senior_project.model.BulletinBoard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BulletinBoardRepository extends JpaRepository<BulletinBoard, Integer> {
}
