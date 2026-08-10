package com.youwin.repository;

import com.youwin.dto.BoardSearchCondition;
import com.youwin.dto.NoticeDto;
import com.youwin.dto.NoticeImageDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface NoticeRepository {

    // 1. 공지사항 작성 (등록)
    // useGeneratedKeys 설정으로 insert 실행 후 noticeDto에 noticeId가 자동으로 채워짐
    int save(NoticeDto noticeDto);

    // 2. 공지사항 조회 구역
    // 전체 목록 조회 (필요 시 기존 기능 호환용)
    List<NoticeDto> findAll();

    // 페이징, 카테고리 필터, 키워드 검색 조건이 적용된 게시글 목록 조회 (검색 조건 객체 사용)
    List<NoticeDto> findAllWithPaging(BoardSearchCondition condition);

    // Map 타입 파라미터를 사용하는 페이징 목록 조회 (기존 코드 호환용)
    List<NoticeDto> findAllWithPagingMap(Map<String, Object> params);

    // 페이징 하단 번호 계산을 위한 조건별 전체 게시글 총 개수 반환 (검색 조건 객체 사용)
    int countTotal(BoardSearchCondition condition);

    // Map 타입 파라미터를 사용하는 총 개수 반환 (기존 코드 호환용)
    int countTotalMap(Map<String, Object> params);

    // 단건 상세 조회 구역
    NoticeDto findById(Long noticeId);

    // 3. 공지사항 수정 구역
    int update(NoticeDto noticeDto);

    // 4. 공지사항 삭제 구역
    int deleteById(Long noticeId);

    // 5. 공지사항 이미지 처리 구역
    // 단일 이미지 등록
    void insertImage(NoticeImageDto imageDto);

    // 다중 이미지 일괄 등록 (MyBatis 동적 쿼리 <foreach>를 위한 @Param 명시)
    void insertNoticeImages(@Param("images") List<NoticeImageDto> images);

    // 특정 공지사항 ID에 묶인 이미지 목록 조회
    List<NoticeImageDto> selectImagesByNoticeId(Long noticeId);

    // 공지사항 글 삭제 시 연결된 모든 이미지 데이터 일괄 제거
    int deleteImagesByNoticeId(Long noticeId);

    // 수정 시 유지되지 않은 개별 이미지를 ID로 삭제
    int deleteImageById(Long imageId);
}