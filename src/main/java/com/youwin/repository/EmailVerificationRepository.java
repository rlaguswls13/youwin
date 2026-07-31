package com.youwin.repository;

import com.youwin.dto.EmailVerificationVo;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDateTime;

@Mapper
public interface EmailVerificationRepository {

    // 1. 인증번호 저장
    void saveVerificationCode(
            @Param("email") String email,
            @Param("code") String code,
            @Param("expiresAt") LocalDateTime expiresAt
    );

    // 2. 가장 최근 생성된 인증 정보 조회 (DTO 대신 간단히 맵이나 클래스로 매핑 가능)
    EmailVerificationVo findLatestByEmail(@Param("email") String email);

    // 3. 인증 완료 상태로 변경 (is_verified = 1)
    void updateVerifiedStatus(@Param("email") String email, @Param("isVerified") boolean isVerified);

    // 4. 최종 인증 완료 여부 확인
    boolean isVerified(@Param("email") String email);

    // 5. 사용 후 삭제
    void deleteByEmail(@Param("email") String email);
}