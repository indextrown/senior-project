package com.starbridge.senior_project.repository;

import com.starbridge.senior_project.model.Dummy;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DummyRepository extends JpaRepository<Dummy, Long> {
}