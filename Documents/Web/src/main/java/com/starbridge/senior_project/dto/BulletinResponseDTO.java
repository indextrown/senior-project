package com.starbridge.senior_project.dto;

import com.starbridge.senior_project.model.BulletinBoard;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BulletinResponseDTO {
    private int number;
    private String nickname;
    private String title;
    private String content;
    private String artist;
    private LocalDateTime postDate;

    public BulletinResponseDTO(BulletinBoard bulletinBoard) {
        this.number = bulletinBoard.getNumber();
        this.nickname = bulletinBoard.getNickname();
        this.title = bulletinBoard.getTitle();
        this.content = bulletinBoard.getContent();
        this.artist = bulletinBoard.getArtist();
        this.postDate = bulletinBoard.getPostDate();
    }
}
