package com.youwin.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class ChatReportDto {

    private Integer reportId;
    private Integer roomId;
    private Integer reporterId;
    private Integer reportedId;
    private String reason;
    private LocalDateTime createdAt;
}
