package com.starbridge.senior_project.repository;

import com.starbridge.senior_project.model.ArtistSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ArtistScheduleRepository extends JpaRepository<ArtistSchedule, Integer> {
}
