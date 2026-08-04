CREATE TABLE member_security (
     member_id varchar(50) NOT NULL COMMENT '회원 아이디 (FK)',
     login_fail_count int NOT NULL DEFAULT 0 COMMENT '연속 로그인 실패 횟수 (1~5회)',
     lock_count int NOT NULL DEFAULT 0 COMMENT '누적 계정 잠금 횟수',
     is_locked tinyint NOT NULL DEFAULT 0 COMMENT '영구/강제 잠금 여부 (0: 정상, 1: 영구잠금)',
     updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
     PRIMARY KEY (member_id),
     CONSTRAINT fk_security_member FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE
) COMMENT='회원 보안 및 로그인 실패 관리';