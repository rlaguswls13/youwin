package com.youwin.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class SongDto {

    private Integer songId;
    private String songTitle;
    private Integer artistId;
    private Integer themeId;
    private String artistName;
    private String themeName;
    private String albumImageUrl;
    private LocalDate releaseDate;
}
