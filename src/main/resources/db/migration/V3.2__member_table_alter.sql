ALTER TABLE member
    ADD deleted_at DATETIME NULL COMMENT '삭제일(탈퇴일)' AFTER updated_at