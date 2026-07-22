-- 1. 데이터베이스 선택 및 안전장치 해제
CREATE DATABASE IF NOT EXISTS youwin;
USE youwin;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS notice_board;
DROP TABLE IF EXISTS faq_board;
DROP TABLE IF EXISTS member;

-- 2. 임시 member 테이블 생성
CREATE TABLE IF NOT EXISTS member (
                                      id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '회원 일련번호',
                                      member_id VARCHAR(50) NOT NULL UNIQUE COMMENT '회원 로그인 아이디',
    name VARCHAR(50) NULL COMMENT '회원 이름'
    ) COMMENT = '회원 정보';

-- 3. 공지사항(notice_board) 테이블 생성
CREATE TABLE notice_board (
                              notice_id   BIGINT          NOT NULL    AUTO_INCREMENT COMMENT '공지사항 번호',
                              member_id   VARCHAR(50)     NULL        COMMENT '작성자 아이디',
                              category    VARCHAR(30)     NOT NULL    DEFAULT '안내' COMMENT '공지 분류(안내/업데이트/이벤트)',
                              title       VARCHAR(200)    NOT NULL    COMMENT '제목',
                              content     TEXT            NOT NULL    COMMENT '내용',
                              `count`     INT             NOT NULL    DEFAULT 0 COMMENT '조회 수',
                              is_pinned   TINYINT         NOT NULL    DEFAULT 0 COMMENT '상단 고정 여부(0:일반, 1:고정)',
                              create_at   DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
                              update_at   DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
                              PRIMARY KEY (notice_id),
                              CONSTRAINT fk_notice_board_member FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='공지사항';

-- 4. FAQ(faq_board) 테이블 생성
CREATE TABLE faq_board (
                           faq_id      BIGINT          NOT NULL    AUTO_INCREMENT COMMENT 'FAQ 번호',
                           member_id   VARCHAR(50)     NULL        COMMENT '작성자 아이디',
                           category    VARCHAR(30)     NOT NULL    DEFAULT '계정' COMMENT '분류(계정/서비스 이용/신고/기타)',
                           title       VARCHAR(200)    NOT NULL    COMMENT '질문 제목',
                           content     TEXT            NOT NULL    COMMENT '답변 내용',
                           `count`     INT             NOT NULL    DEFAULT 0 COMMENT '조회 수',
                           is_public   TINYINT         NOT NULL    DEFAULT 1 COMMENT '공개 여부(0:비공개, 1:공개)',
                           create_at   DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
                           update_at   DATETIME        NOT NULL    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
                           PRIMARY KEY (faq_id),
                           CONSTRAINT fk_faq_board_member FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='FAQ 및 문의';

SET FOREIGN_KEY_CHECKS = 1;

-- 5. 테스트용 기본 데이터 세팅
INSERT IGNORE INTO member (member_id, name) VALUES ('admin', '운영팀');

INSERT INTO notice_board (member_id, category, title, content, is_pinned, `count`) VALUES
                                                                                       ('admin', '안내', '[필독] 커뮤니티 이용 가이드라인 및 기본 에티켓 안내', '안전한 음악 소통을 위한 기본 규칙 안내입니다.', 1, 124),
                                                                                       ('admin', '안내', '[공지] 시스템 정기 점검 안내 (새벽 2시 ~ 6시)', '더 안정적인 서비스를 제공하기 위한 서버 인프라 점검 안내입니다.', 1, 85),
                                                                                       ('admin', '업데이트', 'Youwin 음악 스트리밍 플레이어 로직 최적화 패치노트', '백엔드 오디오 버퍼링 속도가 기존 대비 대폭 향상되었습니다.', 0, 42),
                                                                                       ('admin', '이벤트', '신규 가입 회원 대상 무료 스트리밍 체험 프로모션', '지금 친구를 초대하고 프리미엄 1개월권을 받아가세요.', 0, 99),
                                                                                       ('admin', '안내', '고객센터 평일 운영 시간 변경 공지', '평일 오전 10시부터 오후 6시까지 순차 답변이 진행됩니다.', 0, 15),
                                                                                       ('admin', '업데이트', '채팅방 실시간 이모티콘 팩 추가 업데이트 안내', '소통의 재미를 더할 신규 이모티콘 세트가 오픈되었습니다.', 0, 31),
                                                                                       ('admin', '이벤트', '주간 인기 음원 투표 레이스 참여 경품 안내', '이번 주 최고의 명곡에 투표해 주신 분들 중 추첨을 통해 선물을 드립니다.', 0, 56),
                                                                                       ('admin', '안내', '개인정보 처리방침 개정 건에 대한 사전 고지', '서비스 약관 및 보안 규정 변경에 따른 안내문입니다.', 0, 9),
                                                                                       ('admin', '업데이트', '마이페이지 내 플레이리스트 저장 용량 5배 증설', '기존 최대 100곡 저장 제한을 500곡으로 대폭 확장했습니다.', 0, 67),
                                                                                       ('admin', '이벤트', 'Youwin 론칭 파티 아티스트 모집 공고', '나만의 자작곡을 자랑하고 상금의 주인공이 되어보세요.', 0, 112),
                                                                                       ('admin', '안내', '불법 음원 추출 프로그램 사용 유저 제재 안내', '저작권 보호를 위해 비정상적인 접근은 상시 모니터링됩니다.', 0, 23),
                                                                                       ('admin', '업데이트', '모바일 웹 브라우저 반응형 UI 컴포넌트 개선', '스마트폰 크기에서도 화면 깨짐 없이 깔끔하게 나오도록 보정했습니다.', 0, 38);

INSERT INTO faq_board (member_id, category, title, content) VALUES
                                                                ('admin', '계정', '비밀번호를 분실했는데 어떻게 찾나요?', '로그인 화면 하단의 비밀번호 재설정 링크를 이용해 가입한 이메일로 임시 링크를 전송받으실 수 있습니다.'),
                                                                ('admin', '서비스 이용', '채팅방 실시간 알림을 끄는 방법이 있나요?', '오른쪽 상단 대화방 옵션 메뉴 내부에서 개별 알림 토글을 비활성화 처리할 수 있습니다.');

SELECT * FROM member;
SELECT * FROM notice_board ORDER BY is_pinned DESC, notice_id DESC;
SELECT * FROM faq_board;