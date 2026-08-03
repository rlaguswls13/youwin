create table if not exists reports (
    report_id       int         not null auto_increment comment '신고 고유 번호',
    reporter_id     int         not null comment '신고한 사람 회원 번호',
    reported_id     int         not null comment '신고당한 사람 회원 번호',
    room_id         int         not null comment '어떤 채팅방에서 발생했는지',
    reason          varchar(500) not null comment '신고 사유',
    created_at      datetime    not null default now() comment '신고 일시',
    primary key (report_id)
    ) comment = '회원 신고';