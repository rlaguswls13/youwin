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
SELECT