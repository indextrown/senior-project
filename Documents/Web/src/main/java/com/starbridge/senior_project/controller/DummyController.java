package com.starbridge.senior_project.controller;

import com.starbridge.senior_project.model.Dummy;
import com.starbridge.senior_project.service.DummyService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class DummyController {

    private final DummyService dummyService;

    public DummyController(DummyService dummyService) {
        this.dummyService = dummyService;
    }

    // 기존의 /dummies 엔드포인트
    @GetMapping("/dummies")
    public String getAllDummies(Model model) {
        List<Dummy> dummies = dummyService.getAllDummies();
        model.addAttribute("dummies", dummies);
        return "dummies";
    }

    // 추가된 /events 엔드포인트
    @GetMapping("/events")
    @ResponseBody
    public List<EventDto> getEvents() {
        List<Dummy> dummies = dummyService.getAllDummies();
        return dummies.stream()
                .map(dummy -> new EventDto(dummy.getTitle(), dummy.getEvent_date().toString(), dummy.getDetail()))
                .collect(Collectors.toList());
    }

    // DTO 클래스 정의 (내부 클래스로 정의할 수 있음)
    public static class EventDto {
        private String title;
        private String start;  // event_date를 여기에 매핑
        private String description;

        public EventDto(String title, String start, String description) {
            this.title = title;
            this.start = start;
            this.description = description;
        }

        // Getters and Setters
        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getStart() {
            return start;
        }

        public void setStart(String start) {
            this.start = start;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }
    }
}