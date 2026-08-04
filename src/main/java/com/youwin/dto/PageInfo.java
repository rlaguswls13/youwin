package com.youwin.dto;

public class PageInfo {
    private int page;
    private int totalCount;
    private int totalPages;
    private int startPage;
    private int endPage;
    private boolean prev;
    private boolean next;

    public PageInfo(int page, int totalCount) {
        this.page = page;
        this.totalCount = totalCount;
        this.totalPages = (int) Math.ceil((double) totalCount / 10);
        this.endPage = (int) (Math.ceil(page / 10.0)) * 10;
        this.startPage = this.endPage - 9;
        if (this.endPage > this.totalPages) {
            this.endPage = this.totalPages == 0 ? 1 : this.totalPages;
        }
        this.prev = this.startPage > 1;
        this.next = this.endPage < this.totalPages;
    }

    public int getPage() { return page; }
    public int getTotalCount() { return totalCount; }
    public int getTotalPages() { return totalPages; }
    public int getStartPage() { return startPage; }
    public int getEndPage() { return endPage; }
    public boolean isPrev() { return prev; }
    public boolean isNext() { return next; }
}