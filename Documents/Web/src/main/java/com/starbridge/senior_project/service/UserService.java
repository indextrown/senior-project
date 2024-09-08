package com.starbridge.senior_project.service;

import com.starbridge.senior_project.dto.UserLoginDTO;
import com.starbridge.senior_project.dto.UserResponseDTO;
import com.starbridge.senior_project.model.User;
import com.starbridge.senior_project.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public void save(User user) {
        userRepository.save(user);
    }

    public UserResponseDTO login(UserLoginDTO userLoginDTO) {
        User user = userRepository.findByUserId(userLoginDTO.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("사용자를 찾을 수 없습니다."));

        if (!user.getPassword().equals(userLoginDTO.getPassword())) {
            throw new IllegalArgumentException("비밀번호가 일치하지 않습니다. ");
        }
        UserResponseDTO userResponseDTO = new UserResponseDTO(user);

        return userResponseDTO;
    }

}