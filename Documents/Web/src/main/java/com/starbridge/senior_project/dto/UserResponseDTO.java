package com.starbridge.senior_project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Getter
public class UserResponseDTO {
    private int number;
    private String nickname;

    public UserResponseDTO(User user) {
        this.number = user.getNumber();
        this.nickname = user.getNickname();
    }
}
