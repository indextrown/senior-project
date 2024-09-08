package com.starbridge.senior_project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CreateBulletinBoardDTO {
    private String nickname;
    private String title;
    private String content;
    private String artist;
}
