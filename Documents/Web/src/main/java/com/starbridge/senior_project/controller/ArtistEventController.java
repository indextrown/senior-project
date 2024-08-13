package com.starbridge.senior_project.controller;

import com.starbridge.senior_project.model.ArtistEvent;
import com.starbridge.senior_project.service.ArtistEventService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class ArtistEventController {

    private final ArtistEventService artistEventService;

    public ArtistEventController(ArtistEventService artistEventService) {
        this.artistEventService = artistEventService;
    }

    // 기존의 /dummies 엔드포인트
    @GetMapping("/artistEvent")
    public String getAllEvents(Model model) {
        List<ArtistEvent> artistEvent = artistEventService.getAllEvents();
        model.addAttribute("artistEvent", artistEvent);
        return "artistEvent";
    }

    // 추가된 /events 엔드포인트
    @GetMapping("/events")
    @ResponseBody
    public List<EventDto> getEvents() {
        List<ArtistEvent> artistEvents = artistEventService.getAllEvents();
        return artistEvents.stream()
                .map(artistEvent -> new EventDto(artistEvent.getTitle(), artistEvent.getEvent_date().toString(), artistEvent.getDetail()))
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