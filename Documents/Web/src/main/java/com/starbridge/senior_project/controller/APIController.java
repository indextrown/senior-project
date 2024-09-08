package com.starbridge.senior_project.controller;

import com.starbridge.senior_project.dto.*;
import com.starbridge.senior_project.model.BulletinBoard;
import com.starbridge.senior_project.model.User;
import com.starbridge.senior_project.service.ArtistScheduleService;
import com.starbridge.senior_project.service.BulletinBoardService;
import com.starbridge.senior_project.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class APIController {

    @Autowired
    private ArtistScheduleService artistScheduleService;

    @Autowired
    private UserService userService;

    @Autowired
    private BulletinBoardService bulletinBoardService;

    /*
     * x_db 테이블에 저장된 모든 아티스트 스케줄을 반환
     * HTTP 메서드 : GET
     * HTTP 상태코드: 200 OK
     */
    @GetMapping("/api/schedules")
    @ResponseBody
    public ResponseEntity<List<ArtistScheduleDTO>> getSchedules() {
        List<ArtistScheduleDTO> artistScheduleDTOList = artistScheduleService.getAllSchedules();

        return ResponseEntity.ok(artistScheduleDTOList);
    }

    /*
     * (회원가입 기능) 'users' 테이블에 값 저장
     * HTTP 메서드: POST
     * HTTP 상태코드: 200 OK
     */
//    @PostMapping("/api/users")
//    public String signUp(@RequestBody UserSignupDTO userSignupDTO, Model model) {
//        User user = new User(userSignupDTO);
//        userService.save(user);
//
//        return "loginReturn";
//    }

    @PostMapping("/api/users")
    public String signUp(@RequestBody UserSignupDTO userSignupDTO, Model model) {
        // UserSignupDTO에서 값이 제대로 들어왔는지 확인
        if (userSignupDTO.getUserId() == null || userSignupDTO.getUserId().isEmpty()) {
            throw new IllegalArgumentException("User ID는 필수 값입니다.");
        }

        // User 엔티티 생성 및 필드 설정
        User user = new User(userSignupDTO);

        // User 엔티티를 데이터베이스에 저장
        userService.save(user);

        // 회원가입 후 로그인 페이지로 리다이렉트
        return "redirect:/login";
    }

    /*
     * (로그인 기능) id,pw값 db와 비교하기
     */
    @PostMapping("/api/login")
    public ResponseEntity<UserResponseDTO> login(@RequestBody UserLoginDTO userLoginDTO, HttpSession session) {
        UserResponseDTO userResponseDTO = userService.login(userLoginDTO);

        //세션에 닉네임 정보 저장
        session.setAttribute("nickname", userResponseDTO.getNickname());

        return ResponseEntity.ok(userResponseDTO);
    }

    //    @PostMapping("/api/login")
//    public ResponseEntity<UserResponseDTO> login(@RequestBody UserLoginDTO userLoginDTO) {
//        try {
//            UserResponseDTO response = userService.login(userLoginDTO);
//            return ResponseEntity.ok(response);
//        } catch (IllegalArgumentException e) {
//            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null); // 에러 메시지를 포함시킬 수도 있습니다.
//        }
//    }

    /*
     * (게시글 생성 기능)
     */
    @PostMapping("/api/bulletinBoard")
    public ResponseEntity<BulletinResponseDTO> createBoard(@RequestBody CreateBulletinBoardDTO createBulletinBoardDTO,
                                                           HttpSession session) {
        String nickname = (String) session.getAttribute("nickname");
        createBulletinBoardDTO.setNickname(nickname);

        BulletinBoard bulletinBoard = bulletinBoardService.save(createBulletinBoardDTO);
        BulletinResponseDTO bulletinResponseDTO = new BulletinResponseDTO(bulletinBoard);

        return ResponseEntity.ok(bulletinResponseDTO);
//        BulletinBoard bulletinBoard = bulletinBoardService.save(createBulletinBoardDTO);
//
//        BulletinResponseDTO bulletinResponseDTO = new BulletinResponseDTO(bulletinBoard);
//
//        return ResponseEntity.ok(bulletinResponseDTO);

    }
}
//    @PostMapping("/api/bulletinBoard")
//    public ResponseEntity<BulletinResponseDTO> createBoard(@RequestBody CreateBulletinBoardDTO createBulletinBoardDTO,
//                                                           HttpSession session) {
//        String nickname = (String) session.getAttribute("nickname");
//
//        // CreateBulletinBoardDTO에서 BulletinBoard 엔티티 생성
//        BulletinBoard bulletinBoard = new BulletinBoard();
//        bulletinBoard.setTitle(createBulletinBoardDTO.getTitle());
//        bulletinBoard.setContext(createBulletinBoardDTO.getContext());
//        bulletinBoard.setArtist(createBulletinBoardDTO.getArtist());
//        bulletinBoard.setNickname(nickname);  // 세션에서 가져온 닉네임 설정
//        bulletinBoard.setPostDate(LocalDateTime.now());  // 작성 시간 설정
//
//        // 저장된 엔티티 반환
//        BulletinBoard savedBulletinBoard = bulletinBoardService.save(bulletinBoard);
//
//        // BulletinResponseDTO 생성
//        BulletinResponseDTO bulletinResponseDTO = new BulletinResponseDTO(savedBulletinBoard);
//
//        return ResponseEntity.ok(bulletinResponseDTO);




