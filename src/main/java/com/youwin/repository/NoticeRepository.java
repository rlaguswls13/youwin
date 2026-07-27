package com.youwin.repository;

import com.youwin.dto.NoticeDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface NoticeRepository {

    // 1. 공지사항 작성 (등록) 구역
    // 기존 저장 메서드
    void save(NoticeDto notice);

    // 2. 공지사항 페이지네이션 및 검색 구역
    // 기존 전체 조회 메서드 (필요 시 다른 기능에서 사용 가능하므로 남겨둠)
    List<NoticeDto> findAll();

    // 페이징, 카테고리 필터, 키워드 검색 조건이 적용된 게시글 목록을 조회하는 메서드
    List<NoticeDto> findAllWithPaging(Map<String, Object> params);

    // 페이지네이션 하단 번호 렌더링 계산을 위해 조건에 맞는 전체 게시글 총 개수를 반환하는 메서드
    int countTotal(Map<String, Object> params);

    // 3. 공지사항 삭제 구역
    // delete 쿼리를 호출하기 위한 추상 메서드 선언
    void deleteById(Long noticeId);

    // 4. 공지사항 수정 구역
    // DB 데이터 수정을 위한 매퍼 추상 메서드 선언
    void update(NoticeDto notice);

    // 5. 공지사항 단건 상세 조회 구역
    // 단건 상세 조회 쿼리를 호출하기 위한 추상 메서드 선언 (더블클릭 조회 연동)
    NoticeDto findById(Long noticeId);
}