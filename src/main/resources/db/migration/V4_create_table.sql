-- 화면의 아티스트별 섹션에 들어갈 아티스트 정보를 관리하는 테이블

create table if not exists artists (
    artist_id				int 			not null auto_increment comment '아티스트 고유 번호',
    artist_name 			varchar(30) 	not null comment '아티스트 이름',
    artist_image_url		varchar(300)	null 	 comment '아티스트 사진/경로',
    created_at				datetime		not null default now() comment '등록일',
    primary key (artist_id)
    ) comment = '아티스트' ;


create table if not exists themes (
    theme_id 		int				not null auto_increment comment '장르 고유 번호',
    theme_name		varchar(50)		not null comment '장르 이름',
    created_at		datetime		not null default now() comment '등록일',
    primary key(theme_id)
    ) comment = '장르';

-- 노래별 섹션에 들어갈 곡 정보와 앨범 커버를 관리하는 테이블

create table if not exists songs (
    song_id 		int				not null auto_increment comment '노래 고유 번호',
    song_title 		varchar(50)		not null comment '노래 이름',
    artist_id	    int				not null comment '아티스트 번호 FK(암묵적) -> artists.artist_id',
    theme_id		int				not null comment '장르 번호 FK(암묵적) -> themes.theme_id',
    album_image_url varchar(300)	null	 comment '최신 노래 앨범/이미지 경로',
    release_date    date			null 	 comment '최신 발매일',
    primary key(song_id)
    ) comment = '노래';


-- 생성된 모든 아티스트별/노래별 소통방의 데이터를 관리

create table if not exists chat_rooms(
    room_id		int 					not null auto_increment comment '채팅방 고유 번호',
    room_name		varchar(100) 			not null comment '방 이름',
    room_type		enum('artist','song') 	not null comment '채팅방 구분',
    target_id		int						not null comment '채팅방 대상 번호(암묵적, room_type에 따라 artists.artist_id 또는 songs.song_id 참조)',
    theme_id		int						not null comment '장르 번호 FK(암묵적) -> themes.theme_id',
    created_at		datetime 				not null default now() comment '방 개설 일자',
    primary key(room_id)
    ) comment = '채팅방';

-- 소통방에 현재 어떤 참여자들이 들어와 있는지 실시간 목록을 관리

create table if not exists chat_room_members(
    room_id         int         not null comment '채팅방 번호 FK(암묵적) -> chat_rooms.room_id',
    member_id       int         not null comment '회원 번호 FK(암묵적) -> member.member_id',
    join_at         datetime    not null default now() comment '입장 시간',
    primary key(room_id, member_id)

    ) comment='채팅방 참여자';

create table if not exists chat_messages(
    message_id      int             not null auto_increment comment '메시지 번호',
    room_id         int             not null comment '채팅방 번호 FK(암묵적) -> chat_rooms.room_id ',
    member_id 		int 			not null comment '보낸 회원 번호 FK(암묵적) -> member.member_id',
    message         varchar(1000)   not null comment '메시지 내용',
    sent_at      datetime           not null default now() comment '보낸 시간',
    primary key(message_id)
    ) comment='채팅 메시지';