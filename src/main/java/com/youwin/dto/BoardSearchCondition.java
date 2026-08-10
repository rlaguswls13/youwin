package com.youwin.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BoardSearchCondition {
    // 1. 카테고리 필터 (전체, 공지, FAQ, Q&A 등)
    private String category;

    // 2. 검색어 (없을 경우 null 또는 빈 문자열)
    private String keyword;

    // 3. 검색 종류 (titleContent, title, content, writer 등)
    private String searchType = "titleContent";

    // 4. 사용자가 보고자 하는 현재 페이지 번호 (기본값 1)
    private int page = 1;

    // 5. 한 페이지에 보여줄 게시글 개수 (기본값 10)
    private int size = 10;

    // 서비스 또는 맵퍼에서 페이징 처리를 위해 활용할 offset과 limit 필드
    private int offset;
    private int limit;

    // offset 계산이 필요할 경우를 대비한 편의 메서드 추가 (선택적 활용)
    public int getOffset() {
        return (page - 1) * size;
    }

    public int getLimit() {
        return size;
    }
}