package com.youwin.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ArtistDto {

    private Integer artistId;
    private String artistName;
    private String artistImageUrl;
    private LocalDateTime createdAt;

}
