CREATE TABLE email_verification (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL COMMENT '인증 대상 이메일',
    code VARCHAR(6) NOT NULL COMMENT '인증번호 6자리',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '생성시간',
    expires_at DATETIME NOT NULL COMMENT '만료시간',
    is_verified TINYINT(1) NOT NULL DEFAULT 0 COMMENT '인증 완료 여부 (0:미인증, 1:인증완료)',
    INDEX idx_email (email) COMMENT '이메일 조회 성능 향상용 인덱스'
) COMMENT='이메일 인증번호 관리';