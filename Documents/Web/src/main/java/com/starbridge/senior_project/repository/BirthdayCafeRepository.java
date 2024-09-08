package com.starbridge.senior_project.repository;

import com.starbridge.senior_project.model.BirthdayCafe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BirthdayCafeRepository extends JpaRepository<BirthdayCafe, Integer> {
}

