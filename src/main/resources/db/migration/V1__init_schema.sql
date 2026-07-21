CREATE TABLE member (
    id BIGINT AUTO_INCREMENT COMMENT '회원 고유 일련번호',
    member_id VARCHAR(50) NOT NULL COMMENT '로그인 아이디',
    member_password VARCHAR(255) NOT NULL COMMENT '암호화된 비밀번호',
    nickname VARCHAR(50) NOT NULL COMMENT '사용자 닉네임',
    member_phone VARCHAR(20) NULL COMMENT '휴대폰 번호',
    member_email VARCHAR(100) NOT NULL COMMENT '로그인 이메일',
    profile_image VARCHAR(255) NULL COMMENT '프로필 이미지 저장 경로',
    member_role VARCHAR(20) NOT NULL DEFAULT 'USER' COMMENT '권한 (USER, ADMIN 등)',
    member_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '상태 (ACTIVE, DORMANT, BANNED, DELETED)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (id),
    UNIQUE KEY uq_member_id (member_id),
    UNIQUE KEY uq_member_nickname (nickname),
    UNIQUE KEY uq_member_email (member_email)
) COMMENT '회원';

INSERT INTO member (
    member_id, member_password, nickname, member_phone, member_email, member_role, member_status
) VALUES
      ('user01', '$2a$10$vN3X1Dq9...', '김철수', '010-1234-5678', 'chulsoo@example.com', 'USER', 'ACTIVE'),
      ('user02', '$2a$10$wE4Y2Er0...', '이영희', '010-2345-6789', 'younghee@example.com', 'USER', 'ACTIVE'),
      ('user03', '$2a$10$rT5U3Dt1...', '박민수', '010-3456-7890', 'minsu@example.com', 'USER', 'ACTIVE'),
      ('user04', '$2a$10$yI6O4Fy2...', '최지우', '010-4567-8901', 'jiwoo@example.com', 'USER', 'ACTIVE'),
      ('user05', '$2a$10$uP7I5Gz3...', '정다은', '010-5678-9012', 'daeun@example.com', 'USER', 'ACTIVE'),
      ('user06', '$2a$10$aS8O6Hx4...', '강동원', '010-6789-0123', 'dongwon@example.com', 'USER', 'ACTIVE'),
      ('user07', '$2a$10$dF9P7Jc5...', '한소희', '010-7890-1234', 'sohee@example.com', 'USER', 'ACTIVE'),
      ('user08', '$2a$10$gH0Q8Kv6...', '조세호', '010-8901-2345', 'seho@example.com', 'USER', 'BANNED'),
      ('admin01', '$2a$10$jK1R9Lw7...', '최고관리자', '010-9999-9999', 'admin@example.com', 'ADMIN', 'ACTIVE'),
      ('user09', '$2a$10$lM2S0Mx8...', '이탈자', '010-1111-2222', 'leaver@example.com', 'USER', 'DELETED');

UPDATE member
SET created_at = '2024-01-01 09:00:00'
WHERE member_id IN ('user01', 'user02');