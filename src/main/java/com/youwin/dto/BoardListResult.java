package com.youwin.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@Getter
@AllArgsConstructor
@ToString
public class BoardListResult {
    private final List<NoticeDto> noticeList;
    private final PageInfo pageInfo;
    private final BoardSearchCondition searchCondition;
}