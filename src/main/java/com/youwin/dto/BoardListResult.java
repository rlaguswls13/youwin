package com.youwin.dto;

import java.util.List;

public class BoardListResult {
    private List<NoticeDto> noticeList;
    private PageInfo pageInfo;
    private BoardSearchCondition searchCondition;

    public BoardListResult(List<NoticeDto> noticeList, PageInfo pageInfo, BoardSearchCondition searchCondition) {
        this.noticeList = noticeList;
        this.pageInfo = pageInfo;
        this.searchCondition = searchCondition;
    }

    public List<NoticeDto> getNoticeList() { return noticeList; }
    public PageInfo getPageInfo() { return pageInfo; }
    public BoardSearchCondition getSearchCondition() { return searchCondition; }
}