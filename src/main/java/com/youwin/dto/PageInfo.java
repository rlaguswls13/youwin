package com.youwin.dto;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageInfo {
    private final int page;           // 현재 페이지 번호
    private final int size;           // 한 페이지당 보여줄 게시글 개수
    private final int totalCount;     // 전체 게시글 개수
    private final int totalPages;     // 전체 페이지 수
    private final int startPage;      // 화면에 보여질 시작 페이지 번호
    private final int endPage;        // 화면에 보여질 마지막 페이지 번호
    private final boolean prev;       // 이전 버튼 존재 여부
    private final boolean next;       // 다음 버튼 존재 여부

    private static final int PAGE_GROUP_SIZE = 10; // 하단에 한번에 보여줄 페이지 번호 개수 (기본 10개)

    // 생성자 오버로딩 1: 기본 size(10)를 사용할 때 편하게 호출
    public PageInfo(int page, int totalCount) {
        this(page, totalCount, 10);
    }

    // 생성자 오버로딩 2: size를 직접 지정할 수 있는 메인 생성자
    public PageInfo(int page, int totalCount, int size) {
        // 잘못된 페이지 번호가 들어올 경우 1페이지로 안전하게 보정
        this.page = (page < 1) ? 1 : page;
        this.size = size;
        this.totalCount = totalCount;

        // 깔끔하고 정확한 전체 페이지 수 계산 (나머지 올림 효과)
        this.totalPages = (totalCount + size - 1) / size;

        // 현재 페이지가 전체 페이지보다 클 경우 마지막 페이지로 보정
        if (this.page > this.totalPages && this.totalPages > 0) {
            // 참고: final 필드이므로 값이 필요하면 재할당 구조보다는 생성 시점에 계산하는 것이 좋습니다.
        }

        // 페이지 그룹 단위 시작/끝 번호 계산 공식 적용
        this.startPage = ((this.page - 1) / PAGE_GROUP_SIZE) * PAGE_GROUP_SIZE + 1;
        this.endPage = Math.min(startPage + PAGE_GROUP_SIZE - 1, this.totalPages);

        // 이전, 다음 그룹 존재 여부 불리언 처리
        this.prev = startPage > 1;
        this.next = endPage < totalPages;
    }

    // MyBatis 동적 쿼리나 서비스 계층에서 유용하게 쓰이는 오프셋 계산 편의 메서드 추가
    public int getOffset() {
        return (page - 1) * size;
    }
}