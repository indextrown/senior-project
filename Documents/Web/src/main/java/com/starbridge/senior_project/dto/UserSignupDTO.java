package com.starbridge.senior_project.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UserSignupDTO {
    private String userId;
    private String password;
    private String nickname;
    private String email;


}
