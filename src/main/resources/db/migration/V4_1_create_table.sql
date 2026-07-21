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
    artist_id	    int				not null comment '아티스트 번호',
    theme_id		int				not null comment '장르 번호',
    album_image_url varchar(300)	null	 comment '최신 노래 앨범/이미지 경로',
    release_date    date			null 	 comment '최신 발매일',
    primary key(song_id),

    constraint fk_song_artist foreign key (artist_id)
    references artists(artist_id),

    constraint fk_song_theme foreign key(theme_id)
    references themes(theme_id)
    ) comment = '노래';


-- 생성된 모든 아티스트별/노래별 소통방의 데이터를 관리

create table if not exists chat_rooms(
    room_id		int 					not null auto_increment comment '채팅방 고유 번호',
    room_name		varchar(100) 			not null comment '방 이름',
    target_id		int						not null comment '채팅방 대상 번호(암묵적, room_type에 따라 artists.artist_id 또는 songs.song_id 참조)',
    theme_id		int						not null comment '장르 번호',
    created_at		datetime 				not null default now() comment '방 개설 일자',
    primary key(room_id),

    constraint fk_room_theme foreign key(theme_id)
    references themes(theme_id)
    ) comment = '채팅방';

-- 소통방에 현재 어떤 참여자들이 들어와 있는지 실시간 목록을 관리

create table if not exists chat_room_members(
    room_id         int         not null comment '채팅방 번호',
    member_id       bigint        not null comment '회원 번호',
    join_at         datetime    not null default now() comment '입장 시간',
    primary key(room_id, member_id),

    constraint fk_room_member_room foreign key(room_id)
    references chat_rooms(room_id),

    constraint fk_room_member_member foreign key(member_id)
    references member(id)

    ) comment='채팅방 참여자';

create table if not exists chat_messages(
    message_id      int             not null auto_increment comment '메시지 번호',
    room_id         int             not null comment '채팅방 번호 ',
    member_id 		bigint 			not null comment '보낸 회원 번호',
    message         varchar(1000)   not null comment '메시지 내용',
    sent_at      	datetime        not null default now() comment '보낸 시간',
    primary key(message_id),

    constraint fk_message_room foreign key(room_id)
    references chat_rooms(room_id),

    constraint fk_message_member foreign key(member_id)
    references member(id)
    ) comment='채팅 메시지';




-- 아티스트 목록 조회
SELECT artist_id, artist_name,artist_image_url
FROM artists
ORDER BY artist_name;


-- 노래 목록 조회
SELECT s.song_id,
       s.song_title,
       a.artist_name,
       t.theme_name,
       s.album_image_url,
       s.release_date
FROM songs s
         JOIN artists a
              ON   s.artist_id = a.artist_id
         JOIN themes t
              ON   s.theme_id = t.theme_id
ORDER BY s.release_date


-- 채팅방 목록 조회
SELECT room_id, room_name, room_type,target_id, theme_id
FROM chat_rooms
ORDER BY room_name;


-- 장르 목록 조회
SELECT theme_id, theme_name
FROM themes
ORDER BY theme_name;


-- 장르별 노래 조회
SELECT s.song_id,
       s.song_title,
       a.artist_name,
       t.theme_name,
       s.album_image_url
FROM songs s
         JOIN artists a
              ON   s.artist_id = a.artist_id
         JOIN themes t
              ON   s.theme_id = t.theme_id
WHERE t.theme_id = ?;


-- 아티스트 검색
SELECT artist_id, artist_name, artist_image_url
FROM artists
WHERE artist_name LIKE concat('%', ? ,'%');


-- 노래 검색
SELECT s.song_id,
       s.song_title,
       a.artist_name,
       t.theme_name,
       s.album_image_url
FROM   songs s
           JOIN   artists a
                  ON     s.artist_id = a.artist_id
           JOIN   themes t
                  ON     s.theme_id = t.theme_id
WHERE  s.song_title LIKE concat('%', ? ,'%');