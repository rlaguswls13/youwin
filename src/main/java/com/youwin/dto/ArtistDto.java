package com.youwin.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
public class ArtistDto {

    private Integer artistId;
    private String artistName;
    private String artistImageUrl;
    private LocalDateTime createdAt;

}
