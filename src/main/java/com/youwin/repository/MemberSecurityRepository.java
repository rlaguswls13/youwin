package com.youwin.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberSecurityRepository {

    // 실패 횟수 +1 증가 (없으면 INSERT, 있으면 UPDATE)
    void increaseLoginFailCount(@Param("memberId") String memberId);

    // 계정 잠금 처리 (is_locked = 1)
    void lockAccount(@Param("memberId") String memberId);

    // 로그인 성공 또는 인증 해제 시 초기화
    void resetLoginFailCount(@Param("memberId") String memberId);

    // 잠금 여부 확인 (1: 잠김, 0: 정상)
    boolean isLocked(@Param("memberId") String memberId);

    // 현재 실패 횟수 조회
    int getLoginFailCount(@Param("memberId") String memberId);
}