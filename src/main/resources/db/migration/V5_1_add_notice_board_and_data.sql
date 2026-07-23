-- 1. 혹시 기존에 잘못 생성되었을 수 있는 notice_board만 깔끔하게 제거
DROP TABLE IF EXISTS notice_board;

-- 2. 공지사항(notice_board) 테이블 생성
-- (V1에 선언된 member 테이블의 PK인 'id BIGINT' 구조를 그대로 바라보도록 외래키 매칭)
CREATE TABLE notice_board (
    notice_id BIGINT NOT NULL AUTO_INCREMENT COMMENT '공지사항 번호',
    member_id BIGINT NULL COMMENT '작성자 고유 일련번호(FK)',
    category VARCHAR(30) NOT NULL COMMENT '공지 분류',
    title VARCHAR(200) NOT NULL COMMENT '제목',
    content TEXT NOT NULL COMMENT '내용',
    `count` INT NOT NULL DEFAULT 0 COMMENT '조회 수',
    is_pinned TINYINT NOT NULL DEFAULT 0 COMMENT '상단 고정 여부',
    create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    update_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    PRIMARY KEY (notice_id),
    KEY idx_notice_board_member (member_id),
    CONSTRAINT fk_notice_board_member FOREIGN KEY (member_id) REFERENCES member (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공지사항';

-- 3. [조장 요청사항] 페이징 및 상단고정 확인용 대량 테스트 데이터 INSERT
-- V1에서 이미 삽입된 최고관리자('admin_master'의 id인 1번)를 작성자로 매핑합니다.
INSERT INTO notice_board (member_id, category, title, content, is_pinned, `count`) VALUES
(1, '안내', '[필독] 커뮤니티 이용 가이드라인 및 기본 에티켓 안내', '안전한 소통을 위한 이용 규칙입니다.', 1, 142),
(1, '안내', '[공지] 시스템 정기 점검 안내 (새벽 2시 ~ 6시)', '더 안정적인 서비스를 위한 서버 점검 안내입니다.', 1, 85),
(1, '업데이트', 'Youwin 서비스 버전 1.0.1 패치노트', '백엔드 내부 로직 및 데이터 처리 속도가 대폭 향상되었습니다.', 0, 42),
(1, '이벤트', '신규 가입 회원 대상 무료 이용 프로모션', '지금 친구를 초대하고 1개월 체험권을 받아가세요.', 0, 99),
(1, '안내', '고객센터 평일 운영 시간 변경 공지', '평일 오전 10시부터 오후 6시까지 순차 답변이 진행됩니다.', 0, 15),
(1, '업데이트', '실시간 알림 및 이모티콘 팩 추가 업데이트 안내', '소통의 재미를 더할 신규 기능이 오픈되었습니다.', 0, 31),
(1, '이벤트', '주간 인기 게시글 투표 레이스 참여 경품 안내', '이번 주 최고의 게시글에 투표하고 선물을 챙기세요.', 0, 56),
(1, '안내', '개인정보 처리방침 개정 건에 대한 사전 고지', '서비스 약관 및 보안 규정 변경에 따른 안내문입니다.', 0, 9),
(1, '업데이트', '마이페이지 내 보관함 저장 용량 대폭 증설 안내', '기존 데이터 저장 제한을 최대 5배로 확장했습니다.', 0, 67),
(1, '이벤트', 'Youwin 오픈 기념 선착순 마감 이벤트 안내', '많은 분들이 참여해주신 이벤트가 성황리에 마감되었습니다.', 0, 112),
(1, '안내', '불법 프로그램 사용 유저 악성 게시물 제재 안내', '클린한 보호를 위해 비정상적인 접근은 상시 모니터링됩니다.', 0, 23),
(1, '업데이트', '모바일 웹 브라우저 반응형 UI 화면 개선 완료', '스마트폰 화면에서도 레이아웃이 깔끔하게 나오도록 보정했습니다.', 0, 38);