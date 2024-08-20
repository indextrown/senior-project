package com.starbridge.senior_project.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Getter
@Table(name = "blipdb")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class ArtistSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "number", nullable = false)
    private int number;

    @Column(name = "kind")
    private String kind;

    @Column(name = "title")
    private String title;

    @Column(name = "detail")
    private String detail;

    @Column(name = "singer")
    private String singer;

    @Column(name = "x_id")
    private String x_id;

    @Column(name = "event_date")
    private LocalDate event_date;

    @Column(name = "post_date")
    private LocalDate post_date;

    @Column(name = "url")
    private String url;

    @Column(name = "photo")
    private String photo;


}
