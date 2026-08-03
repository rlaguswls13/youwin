CREATE TABLE member_security (
   member_id varchar(50) NOT NULL COMMENT '회원 아이디 (FK)',
   login_fail_count int NOT NULL DEFAULT 0 COMMENT '연속 로그인 실패 횟수',
   is_locked tinyint(1) NOT NULL DEFAULT 0 COMMENT '계정 잠금 여부 (0: 정상, 1: 잠김)',
   locked_at datetime DEFAULT NULL COMMENT '잠긴 시간',
   locked_until DATETIME NULL COMMENT '최종 계정 잠금 일시',
   updated_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (member_id),
   CONSTRAINT fk_security_member FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE
) COMMENT='회원 보안 및 로그인 실패 관리';