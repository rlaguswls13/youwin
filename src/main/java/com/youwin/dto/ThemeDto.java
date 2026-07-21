package com.youwin.dto;


import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ThemeDto {

    private Integer themeId;
    private String themeName;
    private LocalDateTime createdAt;
}
