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
JOIN theme t
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
ON   s.theme_id = t.theme_id;
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
ON     s.theme_id = t.theme_id;
WHERE  s.song_title LIKE concat('%', ? ,'%');
