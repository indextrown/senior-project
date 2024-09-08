package com.starbridge.senior_project.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Comment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "number", nullable = false)
    private int number;

    @Column(name = "bulletin_board_id", nullable = false)
    private int bulletinBoardId;

    @Column(name = "nickname", nullable = false)
    private String nickname;

    @Column(name = "comment", nullable = false)
    private String comment;

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    @Column(name = "modified_date")
    private LocalDateTime modifiedDate;
}
