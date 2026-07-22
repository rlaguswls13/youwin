-- theme 데이터
INSERT INTO themes(theme_name)
VALUES
    ('발라드'),
    ('댄스'),
    ('힙합'),
    ('인디'),
    ('록'),
    ('POP');

-- Artist 데이터

INSERT INTO artists
(
    artist_name,
    artist_image_url
)
VALUES
    ('아이유','/images/artist/iu.jpg'),
    ('뉴진스','/images/artist/newjeans.jpg'),
    ('DAY6','/images/artist/day6.jpg'),
    ('QWER','/images/artist/qwer.jpg'),
    ('잔나비','/images/artist/jannabi.jpg'),
    ('AKMU','/images/artist/akmu.jpg');


-- Song 데이터
INSERT INTO songs
(
    song_title,
    artist_id,
    theme_id,
    album_image_url,
    release_date
)
VALUES
    ('Love wins all',1,1,'/images/song/lovewinsall.jpg','2024-01-24'),
    ('How Sweet',2,2,'/images/song/howsweet.jpg','2024-05-24'),
    ('Welcome to the Show',3,5,'/images/song/day6.jpg','2024-03-18'),
    ('고민중독',4,5,'/images/song/qwer.jpg','2024-04-01'),
    ('주저하는 연인들을 위해',5,4,'/images/song/jannabi.jpg','2019-03-13'),
    ('Love Lee',6,2,'/images/song/lovelee.jpg','2023-08-21');

-- Chat Room 데이터

INSERT INTO chat_rooms
(
    room_name,
    target_id,
    theme_id
)
VALUES
    ('아이유 팬톡',1,1),
    ('뉴진스 채팅방',2,2),
    ('DAY6 같이 듣기',3,5),
    ('QWER 이야기',4,5),
    ('잔나비 감성방',5,4),
    ('AKMU 노래 추천',6,2);

-- Chat Room Member 데이터 member 테이블의 id 값을 사용

INSERT INTO chat_room_members
(
    room_id,
    member_id
)
VALUES
    (1,1),
    (1,2),
    (1,3),

    (2,1),
    (2,4),

    (3,1),
    (3,5),

    (4,2),
    (4,3),

    (5,4),

    (6,1),
    (6,6);

-- Chat Message 데이터
INSERT INTO chat_messages
(
    room_id,
    member_id,
    message
)
VALUES
    (1,1,'아이유 이번 신곡 너무 좋아요!'),
    (1,2,'저도 계속 듣고 있어요.'),
    (1,3,'라이브도 기대됩니다.'),

    (2,1,'뉴진스 컴백 언제인가요?'),
    (2,4,'이번 컨셉도 너무 좋네요.'),

    (3,1,'DAY6 콘서트 갑니다!'),
    (3,5,'저도 예매 성공했습니다.'),

    (4,2,'QWER 노래 추천해주세요!'),
    (4,3,'고민중독 꼭 들어보세요.'),

    (5,4,'잔나비 감성이 최고입니다.'),

    (6,1,'Love Lee 아직도 매일 들어요.'),
    (6,6,'AKMU는 믿고 듣습니다.');