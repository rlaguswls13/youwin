package com.youwin.controller.dto;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor(access = AccessLevel.PRIVATE)
public class HomeMessage {

    private final String title;
    private final String content;

    public static HomeMessage of(String title, String content) {
        return new HomeMessage(title, content);
    }
}