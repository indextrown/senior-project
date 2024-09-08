package com.starbridge.senior_project.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.List;

@Controller
public class BoardController {

    @Autowired
    private BulletinBoardService bulletinBoardService;

    //게시판 메인 페이지
    @GetMapping("/bulletinBoard")
    public String bulletinBoard(HttpSession session, Model model) {
        String nickname = (String) session.getAttribute("nickname");
        // 'bulletin_board' 테이블의 내용 전부 가져와 html에서 보여주기
        List<BulletinBoard> posts = bulletinBoardService.findAll();
        model.addAttribute("posts", posts);
        model.addAttribute("nickname", nickname);
        return "bulletinBoard";
    }

    //게시판 글 생성 페이지
    @GetMapping("bulletinBoardNew")
    public String bulletinBoardNew(HttpSession session, Model model) {
        String nickname = (String) session.getAttribute("nickname");
        model.addAttribute("nickname", nickname);

        return "bulletinBoardNew";
    }

    //게시판 글 내용 페이지
    @GetMapping("/bulletinBoard/{number}")
    public String getPostDetails(@PathVariable("number") int number, Model model, HttpSession session) {
        String nickname = (String) session.getAttribute("nickname");

        BulletinBoard bulletinBoard = bulletinBoardService.findById(number);
        model.addAttribute("post", bulletinBoard);
        model.addAttribute("nickname", nickname);
        return "bulletinBoardDetail";

    }
}
