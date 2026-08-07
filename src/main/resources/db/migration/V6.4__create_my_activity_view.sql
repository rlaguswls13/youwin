CREATE OR REPLACE VIEW my_activity_view AS
SELECT
    'CHAT' AS act_type,
    room_id AS target_id,
    member_id,
    message AS content,
    sent_at AS act_at,
    CONCAT('/chatroom?roomId=', room_id) AS link_url
FROM chat_messages

UNION ALL

SELECT
    'NOTICE' COLLATE utf8mb4_unicode_ci AS act_type,
    notice_id AS target_id,
    member_id,
    title COLLATE utf8mb4_unicode_ci AS content,
    update_at AS act_at,
    CONCAT('/board/detail?noticeId=', notice_id) COLLATE utf8mb4_unicode_ci AS link_url
FROM notice_board;