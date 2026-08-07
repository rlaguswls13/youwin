package com.youwin.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageInfo {
    private int page;           // 현재 페이지 번호
    private int totalCount;     // 전체 게시글 개수
    private int size;           // 한 페이지당 보여줄 게시글 개수
    private int navSize;        // 하단 페이지 번호 개수 (예: 1~10)

    private int totalPages;     // 전체 페이지 수
    private int startPage;      // 화면에 보여질 시작 페이지 번호
    private int endPage;        // 화면에 보여질 마지막 페이지 번호

    private boolean prev;       // 이전 버튼 존재 여부
    private boolean next;       // 다음 버튼 존재 여부

    public PageInfo(int page, int totalCount) {
        this(page, totalCount, 10, 10);
    }

    public PageInfo(int page, int totalCount, int size, int navSize) {
        this.page = page;
        this.totalCount = totalCount;
        this.size = size;
        this.navSize = navSize;

        // 전체 페이지 수 계산
        this.totalPages = (int) Math.ceil((double) totalCount / size);

        // 현재 페이지가 전체 페이지보다 클 경우 보정
        if (this.page > this.totalPages && this.totalPages > 0) {
            this.page = this.totalPages;
        }

        // 하단 시작/마지막 페이지 계산
        this.endPage = (int) (Math.ceil((double) page / navSize) * navSize);
        this.startPage = endPage - navSize + 1;

        if (endPage > totalPages) {
            endPage = totalPages;
        }

        // 이전, 다음 활성화 여부
        this.prev = startPage > 1;
        this.next = endPage < totalPages;
    }
}