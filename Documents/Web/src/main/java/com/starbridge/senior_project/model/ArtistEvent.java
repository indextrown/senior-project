package com.starbridge.senior_project.model;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "artist_events")
public class ArtistEvent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer number;

    private String kind;
    private String title;
    private String detail;
    private String x_id;
    private Date event_date;
    private Date post_date;
    private String url;
    private String photo;
    private String singer;

    // Getters and Setters
    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public String getKind() {
        return kind;
    }

    public void setKind(String kind) {
        this.kind = kind;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getX_id() {
        return x_id;
    }

    public void setX_id(String x_id) {
        this.x_id = x_id;
    }

    public Date getEvent_date() {
        return event_date;
    }

    public void setEvent_date(Date event_date) {
        this.event_date = event_date;
    }

    public Date getPost_date() {
        return post_date;
    }

    public void setPost_date(Date post_date) {
        this.post_date = post_date;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getSinger() {
        return singer;
    }

    public void setSinger(String singer) {
        this.singer = singer;
    }
}