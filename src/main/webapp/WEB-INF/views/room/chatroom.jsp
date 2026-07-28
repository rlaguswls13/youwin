<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!doctype html>
        <html lang="ko">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta name="description" content="Youwin 음악 오픈 채팅방">
            <title>채팅방 | Youwin</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/chatroom.css">
        </head>
        <body>
        <div class="site-shell">
            <header class="site-header">
                <div class="site-container site-header__inner">
                    <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
                    <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                        <a href="${pageContext.request.contextPath}/">홈</a>
                        <a href="${pageContext.request.contextPath}/board">게시판</a>
                        <a class="is-active" href="${pageContext.request.contextPath}/chatroom">채팅방</a>
                        <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
                    </nav>
                    <div class="site-header__actions"><span class="chip chip--live">온라인</span><a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a></div>
                    <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
                </div>
            </header>
            <main class="chat-page">
                <div class="chat-shell">
                    <aside class="chat-rooms" data-rooms-panel aria-label="채팅방 목록">
                        <div class="chat-panel__head">
                        <div><h2>나의 대화방</h2><span id="room-count">가입한 대화방 ${fn:length(roomList)}</span></div></div>
                        <div class="room-search"><label class="sr-only" for="room-search">채팅방 검색</label><input id="room-search" type="search" placeholder="채팅방 검색"></div>
                        <div class="room-list">
                         <c:choose>

                             <c:when test="${empty roomList}">
                                 <p class="room-list__empty">가입한 채팅방이 없습니다.</p>
                             </c:when>

                           <c:otherwise>

                           <c:forEach var="room" items="${roomList}">
                               <div class="room-item-wrapper" data-room-id="${room.roomId}">

                               <a href="${pageContext.request.contextPath}/chatroom?roomId=${room.roomId}&memberId=${param.memberId}"
                                  class="room-item ${param.roomId == room.roomId ? 'is-active' : ''}"
                                  data-room-item data-room-name="${room.roomName}">
                                   <span class="room-item__art">🎵</span>

                                   <span>
                                       <strong class="room-item__name">
                                           ${room.roomName}
                                       </strong>
                                   <span class="room-item__preview">
                                       음악 채팅방
                                   </span>

                                 </span>
                              </a>
                              <button type="button" class="leave-room-btn" data-room-id="${room.roomId}">
                                  나가기
                              </button>

                             </div>

                           </c:forEach>

                      </c:otherwise>

                    </c:choose>
                    <div id="empty-room-message" class="room-list__empty" style="display:none;">검색 결과가 없습니다.
                       </div>
                     </div>
                    </aside>
                    <section class="chat-conversation" aria-labelledby="conversation-title">
                        <header class="conversation-head">
                            <button class="icon-button mobile-panel-button" type="button" data-rooms-toggle aria-label="채팅방 목록 열기" aria-expanded="false">☰</button>
                            <div class="room-item__art">🎵</div>
                            <div class="conversation-head__info"><h2 data-room-title>
                                <c:choose>
                                    <c:when test="${not empty room}">
                                    ${room.roomName}
                                    </c:when>

                                    <c:otherwise>
                                        참여 중인 채팅방이 없습니다.
                                    </c:otherwise>
                                </c:choose>
                            </h2>

                                    <c:choose>
                                    <c:when test="${not empty room}">
                                    <p><span class="online-dot">●</span>
                                    <span id="room-member-count">
                                    ${fn:length(memberList)}명
                                    </span>
                                    참여 중 · ${room.roomDescription}
                                    </p>

                                    </c:when>

                                    <c:otherwise>
                                    <p></p>
                                    </c:otherwise>
                                    </c:choose>

                              </div>
                                <div class="conversation-head__actions">

                                   <button id="room-menu-button" class="icon-button" type="button">···</button>
                                   <div id="room-menu" class="room-menu">
                                   <c:if test="${!joined}">
                                   <button id="join-room-btn" class="room-menu__item" data-room-id="${room.roomId}">가입하기</button>
                                   </c:if>

                                       <button id="edit-room-btn" class="room-menu__item">채팅방 수정</button>

                                       <button id="room-info-btn" class="room-menu__item">채팅방 정보</button>

                                       <button id="favorite-room-btn" class="room-menu__item">즐겨찾기</button>

                                       <button id="report-room-btn" class="room-menu__item report">신고하기</button>

                                   </div>
                                </div>
                        </header>

                        <div class="message-list" data-message-list aria-live="polite">
                            <div class="message-date">이전 채팅</div>

                            <c:forEach var="message" items="${messageList}">

                                <div class="message ${message.memberId == loginMemberId ? 'my-message' : 'other-message'}">

                                    <c:if test="${message.memberId != loginMemberId}">
                                        <div class="message__avatar"></div>
                                    </c:if>

                                    <div class="message__body">

                                        <c:if test="${message.memberId != loginMemberId}">
                                            <div class="message__author">${message.nickname}</div>
                                        </c:if>

                                        <div class="message__row">

                                            <div class="message__bubble">${message.message}</div>

                                            <div class="message__time" data-time="${message.sentAt}"></div>
                                        </div>
                                    </div>
                                </div>

                            </c:forEach>
                        </div>

                        <form class="message-composer" data-message-form>
                            <div class="message-composer__box"><button class="icon-button" type="button" aria-label="파일 첨부">＋</button><label class="sr-only" for="message-input">메시지 입력</label><textarea id="message-input" data-message-input rows="1" maxlength="1000" placeholder="메시지를 입력하세요"></textarea><button class="send-button" type="submit">전송</button></div>
                            <p class="composer-help"></p>
                        </form>
                    </section>
                    <aside class="chat-members" aria-label="참여자 목록">

                        <div class="chat-panel__head">
                            <div>
                                <h3>참여자</h3>
                                <span id="member-count">${fn:length(memberList)}명</span>
                            </div>
                        </div>

                        <div id="member-list">
                            <c:forEach var="member" items="${memberList}">
                                <div class="member-item">
                                    <span class="avatar">
                                        ${member.nickname.substring(0,1)}
                                    </span>

                                    <span>
                                        <strong class="member-item__name">
                                            ${member.nickname}
                                        </strong>

                                    <span class="member-item__status">
                                        <span class="online-dot">●</span>
                                        참여중
                                    </span>

                                  </span>

                                </div>
                            </c:forEach>
                        </div>

                    </aside>
        <div id="edit-room-modal" class="modal">
            <div class="modal-content">
                    <h2>채팅방 수정</h2>

                <label for="edit-room-btn">채팅방 이름</label>
                <input type="text" id="edit-room-name" value="${room.roomName}">

                <label for="edit-room-description">방 설명</label>
                <textarea id="edit-room-description">${room.roomDescription}</textarea>

                <label for="edit-room-artist">아티스트</label>
                <select id="edit-room-artist"></select>

                <label for="edit-room-theme">장르</label>
                <select id="edit-room-theme">
                    <c:forEach var="theme" items="${themeList}">

                        <option value="${theme.themeId}" ${theme.themeId == room.themeId ? 'selected' : ''}>
                                ${theme.themeName}
                        </option>

                    </c:forEach>

                </select>

                <div class="modal-buttons"></div>
                <button type="button" id="edit-room-cancel">취소</button>
                <button type="button" id="edit-room-save">수정</button>
            </div>
           </div>
          </div>
          </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/sockjs-client/dist/sockjs.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.2.0/bundles/stomp.umd.min.js"></script>

        <script src="${pageContext.request.contextPath}/app.js"></script>
        <script> const loginMemberId = ${loginMemberId};</script>
        <script src="${pageContext.request.contextPath}/chatroom.js"></script>
        </body>
        </html>
