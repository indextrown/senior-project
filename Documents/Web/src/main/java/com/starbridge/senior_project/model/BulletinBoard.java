package com.starbridge.senior_project.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "bulletin_board")
@NoArgsConstructor
public class BulletinBoard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "number", nullable = false)
    private int number;

    @Column(name = "nickname", nullable = false)
    private String nickname;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "content", nullable = false)
    private String content;

    @Column(name = "post_date")
    private LocalDateTime postDate;

    @Column(name = "artist")
    private String artist;

    @Column(name = "likes")
    private int likes = 0;

    @Column(name = "view")
    private int view = 0;

    @PrePersist
    public void prePersist() {
        this.postDate = LocalDateTime.now();
    }

    public BulletinBoard(CreateBulletinBoardDTO createBulletinBoardDTO) {
        this.nickname = createBulletinBoardDTO.getNickname();
        this.title = createBulletinBoardDTO.getTitle();
        this.content = createBulletinBoardDTO.getContent();
        this.artist = createBulletinBoardDTO.getArtist();
    }
}