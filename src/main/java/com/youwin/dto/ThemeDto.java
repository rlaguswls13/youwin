package com.youwin.dto;


import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ThemeDto {

    private Integer themeId;
    private String themeName;
    private LocalDateTime createdAt;
}
