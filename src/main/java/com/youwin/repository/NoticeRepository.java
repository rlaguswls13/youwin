package com.youwin.repository;

import com.youwin.dto.NoticeDto;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface NoticeRepository {

    // 1. 기존 전체 조회 메서드 (유지)
    List<NoticeDto> findAll();

    // 2. 기존 저장 메서드 (유지)
    void save(NoticeDto notice);

    // 💡 3. [추가] XML에 작성한 delete 쿼리를 호출하기 위한 추상 메서드 선언
    void deleteById(Long noticeId);
}