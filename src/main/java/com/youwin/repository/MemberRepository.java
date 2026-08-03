package com.youwin.repository;

import com.youwin.dto.MemberDto;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;

@Mapper
public interface MemberRepository {
    void insertMember(MemberDto member);
    // 아이디 개수 조회 (존재하면 1 이상, 없으면 0)
    int countByMemberId(@Param("memberId") String memberId);
    // 닉네임 개수 조회 (존재하면 1 이상, 없으면 0)
    int countByNickname(@Param("nickname") String nickname);
    // 이메일 개수 조회 (존재하면 1 이상, 없으면 0)
    int countByMemberEmail(@Param("memberEmail") String memberEmail);
    // 회원 존재 여부 확인 (아이디찾기)
    boolean existsByNameAndEmail(@Param("memberName") String memberName, @Param("memberEmail") String memberEmail);
    // 이름과 이메일로 아이디 조회
    String findMemberIdByNameAndEmail(@Param("memberName") String memberName,
                                      @Param("memberEmail") String memberEmail);
    // 로그인용 회원 정보 단건 조회
    MemberDto findByMemberId(@Param("memberId") String memberId);
    // 로그인 아이디(member_id)로 실제 회원 PK(id) 조회
    Integer findIdByMemberId(@Param("memberId") String memberId);
    // 회원 존재 여부 확인 (비밀번호 찾기)
    boolean existsByIdAndEmail(@Param("memberId") String memberId,
                               @Param("memberEmail") String memberEmail);

    void updatePassword(@Param("memberId") String memberId,
                       @Param("memberPassword") String memberPassword);

    void updateNickname(@Param("memberId") String memberId, @Param("nickname") String nickname);
    void updatePhone(@Param("memberId") String memberId, @Param("memberPhone") String memberPhone);
    void updateEmail(@Param("memberId") String memberId, @Param("memberEmail") String memberEmail);
    void updateProfileImage(@Param("memberId") String memberId, @Param("profileImage") String profileImage);

    void deleteMember(String memberId);

    // 탈퇴 회원 삭제
    int deleteExpiredMembers(@Param("cutoffDate") LocalDateTime cutoffDate);

    // 1. 로그인 성공 시 마지막 로그인 시간 업데이트
    int updateLastLoginAt(@Param("memberId") String memberId);

    // 2. 장기 미접속 계정을 DORMANT(휴면)로 전환 (기준 일시 전달)
    int convertToDormantAccounts(@Param("cutoffDate") LocalDateTime cutoffDate);

    // 3. 휴면 계정 인증 해제 (DORMANT -> ACTIVE 및 로그인 시간 갱신)
    int activateDormantAccount(@Param("memberId") String memberId);

    int cancelDeleteMember(@Param("memberId") String memberId);
}
