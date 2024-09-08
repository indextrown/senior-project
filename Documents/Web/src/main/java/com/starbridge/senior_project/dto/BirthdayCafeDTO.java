package com.starbridge.senior_project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Date;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class BirthdayCafeDTO {
    private int number;
    private String celebrity;
    private String uploader;
    private Date startDate;
    private Date endDate;
    private String place;
    private String postUrl;

    public BirthdayCafeDTO(BirthdayCafe birthdayCafe) {
        this.number = birthdayCafe.getNumber();
        this.celebrity = birthdayCafe.getCelebrity();
        this.uploader = birthdayCafe.getUploader();
        this.startDate = birthdayCafe.getStartDate();
        this.endDate = birthdayCafe.getEndDate();
        this.place = birthdayCafe.getPlace();
        this.postUrl = birthdayCafe.getPostUrl();
    }
}