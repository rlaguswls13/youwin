package com.youwin.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberSecurityRepository {

    /**
     * 로그인 실패 횟수 1 증가 (없으면 Insert, 있으면 login_fail_count + 1)
     */
    void increaseLoginFailCount(@Param("memberId") String memberId);

    /**
     * 계정 잠금 처리 (실패 5회 도달 시: lock_count + 1, 3회 이상 시 is_locked = 1)
     */
    void lockAccount(@Param("memberId") String memberId);

    /**
     * 로그인 성공 또는 이메일 본인 인증 성공 시 보안 데이터 전체 리셋
     */
    void resetLoginFailCount(@Param("memberId") String memberId);

    /**
     * 잠금 상태 여부 확인 (최근 30분 이내 잠김 OR lock_count 3회 이상 영구 잠금)
     */
    boolean isLocked(@Param("memberId") String memberId);

    /**
     * 현재 연속 로그인 실패 횟수 조회 (1~5회)
     */
    int getLoginFailCount(@Param("memberId") String memberId);
}