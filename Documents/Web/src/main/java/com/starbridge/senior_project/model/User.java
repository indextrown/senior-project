package com.starbridge.senior_project.model;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Getter
@Table(name = "users")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "number", nullable = false)
    private int number;

    @Column(name = "user_id", nullable = false, unique = true)
    private String userId;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "nickname", nullable = false, unique = true)
    private String nickname;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "provider")
    private String provider;

    @Column(name = "social_id")
    private String socialId;

    @Column(name = "created_date")
    private LocalDateTime createdDate;

    @Column(name = "modified_date")
    private LocalDateTime modifiedDate;

    @PrePersist
    public void prePersist() {
        this.createdDate = LocalDateTime.now();
        this.modifiedDate = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.modifiedDate = LocalDateTime.now();
    }

    public User(UserSignupDTO userSignupDTO) {
        this.userId = userSignupDTO.getUserId();
        this.password = userSignupDTO.getPassword();
        this.nickname = userSignupDTO.getNickname();
        this.email = userSignupDTO.getEmail();
    }

    public User(UserLoginDTO userLoginDTO) {
        this.userId= userLoginDTO.getUserId();
        this.password = userLoginDTO.getPassword();
    }
}
