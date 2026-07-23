package com.youwin.dto;

import lombok.*;

import java.time.LocalDate;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
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
