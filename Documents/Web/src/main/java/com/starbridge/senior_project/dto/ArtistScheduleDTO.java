package com.starbridge.senior_project.dto;

import com.starbridge.senior_project.model.ArtistSchedule;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ArtistScheduleDTO {

    private int number;
    private String kind;
    private String title;
    private String detail;
    private String artist;
    private String id;
    private LocalDate event_date;
    private LocalDate post_date;
    private String url;
    private String photo;

    public ArtistScheduleDTO(ArtistSchedule artistSchedule){
        this.number = artistSchedule.getNumber();
        this.kind = artistSchedule.getKind();
        this.title = artistSchedule.getKind();
        this.detail = artistSchedule.getDetail();
        this.artist = artistSchedule.getArtist();
        this.id = artistSchedule.getId();
        this.event_date = artistSchedule.getEvent_date();
        this.post_date = artistSchedule.getPost_date();
        this.url = artistSchedule.getUrl();
        this.photo = artistSchedule.getPhoto();

    }
}
