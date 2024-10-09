package com.starbridge.senior_project.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Getter
@Setter
@Table(name = "cafe_db")
@NoArgsConstructor
public class BirthdayCafe {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "number", nullable = false)
    private int number;

    @Column(name = "celebrity")
    private String celebrity;

    @Column(name = "uploader")
    private String uploader;

    @Temporal(TemporalType.DATE)
    @Column(name = "start_date")
    private Date startDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "end_date")
    private Date endDate;

    @Column(name = "place")
    private String place;

    @Column(name = "post_url")
    private String postUrl;

    @Column(name = "address")
    private String address;
}
