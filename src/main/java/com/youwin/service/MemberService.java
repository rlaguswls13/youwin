package com.youwin.service;

import com.youwin.dto.AutoLoginDto;
import com.youwin.dto.MemberDto;
import com.youwin.repository.MemberRepository;
import com.youwin.repository.AutoLoginRepository;
import com.youwin.security.CustomUserDetails;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final AutoLoginRepository autoLoginRepository;
    private final PasswordEncoder passwordEncoder;
    private final EmailVerificationService emailVerificationService;

    // SecurityContext 내의 MemberDto 정보 갱신용 보조 메서드
    private void refreshSecurityContext(String memberId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof CustomUserDetails) {
            MemberDto updatedMember = memberRepository.findByMemberId(memberId);
            updatedMember.setMemberPassword(null); // 보안상 비밀번호 제거

            CustomUserDetails newDetails = new CustomUserDetails(updatedMember);
            UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(
                    newDetails, auth.getCredentials(), newDetails.getAuthorities()
            );
            SecurityContextHolder.getContext().setAuthentication(newAuth);
        }
    }

    @Transactional
    public void joinMember(MemberDto memberDto) {
        // 이메일 인증 완료 여부 검증
        if (!emailVerificationService.isVerified(memberDto.getMemberEmail())) {
            throw new IllegalStateException("이메일 인증이 완료되지 않았습니다.");
        }

        // 1. 비밀번호 암호화
        String encodedPassword = passwordEncoder.encode(memberDto.getMemberPassword());
        memberDto.setMemberPassword(encodedPassword);

        // 2. 프로필 이미지 파일 저장 처리
        MultipartFile profileFile = memberDto.getProfile();

        if (profileFile != null && !profileFile.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            String uploadPath = projectPath + File.separator + "upload" + File.separator + "profile" + File.separator;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String originalFilename = profileFile.getOriginalFilename();
            String uuid = UUID.randomUUID().toString();
            String savedFileName = uuid + "_" + originalFilename;

            File dest = new File(uploadPath, savedFileName);

            try {
                // ① 파일 먼저 디스크에 저장
                profileFile.transferTo(dest);

                // ② 🎯 [핵심] 만약 이 트랜잭션이 최종적으로 '롤백'되면 저장된 파일을 삭제하라고 이벤트 등록!
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCompletion(int status) {
                        if (status == STATUS_ROLLED_BACK && dest.exists()) {
                            dest.delete(); // DB 저장 실패 시 물리 파일 삭제
                        }
                    }
                });

                String dbFilePath = "/upload/profile/" + savedFileName;
                memberDto.setProfileImage(dbFilePath);

            } catch (IOException e) {
                e.printStackTrace();
                throw new RuntimeException("프로필 이미지 저장 중 오류가 발생했습니다.", e);
            }
        } else {
            memberDto.setProfileImage(null);
        }

        // 3. DB INSERT (여기서 에러가 나면 트랜잭션이 롤백되면서 위에서 등록한 파일 삭제 이벤트가 자동으로 실행됨)
        memberRepository.insertMember(memberDto);

        // 회원가입 성공 후 사용했던 이메일 인증 데이터 정리
        emailVerificationService.removeVerification(memberDto.getMemberEmail());
    }

    // 아이디 중복 여부 확인 비즈니스 로직
    public boolean isIdDuplicate(String memberId) {
        int count = memberRepository.countByMemberId(memberId);
        return count > 0; // 1 이상이면 true(중복), 0이면 false(사용가능)
    }

    // 닉네임 중복 여부 확인 비즈니스 로직
    public boolean isNicknameDuplicate(String nickname) {
        int count = memberRepository.countByNickname(nickname);
        return count > 0;
    }

    // 이메일 중복 여부 확인 비즈니스 로직
    public boolean isEmailDuplicate(String memberEmail) {
        int count = memberRepository.countByMemberEmail(memberEmail);
        return count > 0;
    }

    @Transactional
    public void setupAutoLogin(String memberId, HttpServletResponse response) {
        String token = UUID.randomUUID().toString();

        int amount = 60 * 60 * 24 * 7; // 7일
        Date limitDate = new Date(System.currentTimeMillis() + ((long) amount * 1000));

        // DTO 조립 후 upsert 실행
        AutoLoginDto autoLoginDto = new AutoLoginDto();
        autoLoginDto.setMemberId(memberId);
        autoLoginDto.setToken(token);
        autoLoginDto.setLimitDate(limitDate);

        // 🎯 기존 deleteByMemberId 호출 제거 + upsertToken 하나만 실행!
        autoLoginRepository.upsertToken(autoLoginDto);

        // 쿠키 생성 및 전달
        Cookie cookie = new Cookie("remember-me", token);
        cookie.setPath("/");
        cookie.setMaxAge(amount);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    // 자동 로그인 전용: 비밀번호 검증 없이 아이디로 회원 정보 조회
    public MemberDto getMemberById(String memberId) {
        MemberDto memberDto = memberRepository.findByMemberId(memberId);

        if (memberDto != null) {
            // 기존 login 메서드처럼 세션 저장 전 비밀번호 제거
            memberDto.setMemberPassword(null);
        }

        return memberDto;
    }

    // [자동 로그인 2] 토큰 삭제 (로그아웃 시)
    @Transactional
    public void removeAutoLoginToken(String token) {
        autoLoginRepository.deleteByToken(token);
    }

    // 아이디찾기
    // 1. [이메일 발송 전] 해당 회원 존재 여부 확인용 (boolean)
    public boolean existsByNameAndEmail(String memberName, String memberEmail) {
        return memberRepository.existsByNameAndEmail(memberName, memberEmail);
    }

    // 2. [인증 완료 후] 아이디 최종 조회
    public String findMemberId(String memberName, String memberEmail) {
        // 1) 이메일 인증 완료 여부 확인
        if (!emailVerificationService.isVerified(memberEmail)) {
            throw new IllegalStateException("이메일 인증이 완료되지 않았습니다.");
        }

        // 2) 이름과 이메일로 아이디 조회
        String foundMemberId = memberRepository.findMemberIdByNameAndEmail(memberName, memberEmail);

        if (foundMemberId == null) {
            throw new IllegalArgumentException("일치하는 회원 정보가 없습니다.");
        }

        // 3) 아이디 반환 후 인증 데이터 삭제 (일회성 인증 처리)
        emailVerificationService.removeVerification(memberEmail);

        return foundMemberId;
    }

    // 1. 아이디 & 이메일 존재 여부 확인
    public boolean existsByIdAndEmail(String memberId, String memberEmail) {
        return memberRepository.existsByIdAndEmail(memberId, memberEmail);
    }

    // 비밀번호 재설정
    @Transactional
    public void updatePassword(String memberId, String memberEmail, String newPassword) {
        // 1. 이메일 인증 완료 여부 최종 확인
        if (!emailVerificationService.isVerified(memberEmail)) {
            throw new IllegalStateException("이메일 인증이 완료되지 않았습니다.");
        }

        // 2. BCrypt 암호화
        String encodedPassword = passwordEncoder.encode(newPassword);

        // 3. DB 업데이트
        memberRepository.updatePassword(memberId, encodedPassword);

        // 4. 비밀번호 변경 후 인증 정보 삭제
        emailVerificationService.removeVerification(memberEmail);
    }

    // 닉네임 변경
    @Transactional
    public void updateNickname(String memberId, String nickname) {
        memberRepository.updateNickname(memberId, nickname);
        refreshSecurityContext(memberId);
    }

    // 전화번호 변경
    @Transactional
    public void updatePhone(String memberId, String memberPhone) {
        memberRepository.updatePhone(memberId, memberPhone);
        refreshSecurityContext(memberId);
    }

    // 이메일 변경
    @Transactional
    public void updateEmail(String memberId, String memberEmail) {
        memberRepository.updateEmail(memberId, memberEmail);
        refreshSecurityContext(memberId);
    }

    // 비밀번호 변경 (설정 페이지용)
    @Transactional
    public void updatePasswordInSettings(String memberId, String currentPassword, String newPassword) {

        // 1) 회원 조회 및 현재 비밀번호 검증
        MemberDto member = memberRepository.findByMemberId(memberId);
        if (member == null || !passwordEncoder.matches(currentPassword, member.getMemberPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
        }

        // 2) 새 비밀번호가 기존 비밀번호와 동일한지 검증
        if (passwordEncoder.matches(newPassword, member.getMemberPassword())) {
            throw new IllegalArgumentException("현재 비밀번호와 동일한 비밀번호로는 변경할 수 없습니다.");
        }

        // 3) 새 비밀번호 암호화 후 변경
        String encodedPassword = passwordEncoder.encode(newPassword);
        memberRepository.updatePassword(memberId, encodedPassword);
    }

    // 프로필 이미지 변경 (또는 기본 이미지로 변경)
    @Transactional
    public void updateProfileImage(String memberId, MultipartFile profile, boolean deleteProfile) {
        // 0) 기존 회원 정보 조회 (기존 파일 삭제용)
        MemberDto currentMember = memberRepository.findByMemberId(memberId);
        String oldFilePath = currentMember != null ? currentMember.getProfileImage() : null;

        // 1) 기본 이미지로 변경 요청 시
        if (deleteProfile) {
            memberRepository.updateProfileImage(memberId, null); // DB 경로 null 처리
            deletePhysicalFile(oldFilePath); // 기존 실물 파일 삭제
            return;
        }

        // 2) 새 사진 업로드 처리
        if (profile != null && !profile.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            String uploadPath = projectPath + File.separator + "upload" + File.separator + "profile" + File.separator;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String savedFileName = UUID.randomUUID().toString() + "_" + profile.getOriginalFilename();
            File dest = new File(uploadPath, savedFileName);

            try {
                // 실물 파일 저장
                profile.transferTo(dest);

                // 🎯 DB 트랜잭션 종료 시 실행할 동기화 이벤트 등록
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCompletion(int status) {
                        if (status == STATUS_ROLLED_BACK && dest.exists()) {
                            // DB 롤백 시 방금 저장한 신규 파일 삭제
                            dest.delete();
                        } else if (status == STATUS_COMMITTED) {
                            // DB 변경 커밋 성공 시에만 기존 옛날 파일 삭제
                            deletePhysicalFile(oldFilePath);
                        }
                    }
                });

                String dbFilePath = "/upload/profile/" + savedFileName;
                memberRepository.updateProfileImage(memberId, dbFilePath);

            } catch (IOException e) {
                throw new RuntimeException("프로필 사진 변경 중 오류가 발생했습니다.", e);
            }
        }
        refreshSecurityContext(memberId);
    }

    // [보조 메서드] 실물 파일 삭제
    private void deletePhysicalFile(String dbFilePath) {
        if (dbFilePath != null && !dbFilePath.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            File fileToDelete = new File(projectPath + dbFilePath.replace("/", File.separator));
            if (fileToDelete.exists()) {
                fileToDelete.delete();
            }
        }
    }

    // 1. 비밀번호 일치 여부 확인
    public boolean checkPassword(String memberId, String rawPassword) {
        MemberDto memberDto = memberRepository.findByMemberId(memberId);

        if (memberDto == null) {
            return false;
        }

        return passwordEncoder.matches(rawPassword, memberDto.getMemberPassword());
    }

    // 2. 계정 삭제 (status를 DELETED로 변경)
    @Transactional
    public void deleteMember(String memberId) {
        memberRepository.deleteMember(memberId);
    }

    // 로그인 성공 시 호출
    @Transactional
    public void updateLastLoginAt(String memberId) {
        memberRepository.updateLastLoginAt(memberId);
    }

    // 1. 휴면 해제
    @Transactional
    public void activateDormantAccount(String memberId, String memberEmail) {
        if (!emailVerificationService.isVerified(memberEmail)) {
            throw new IllegalStateException("이메일 인증이 완료되지 않았습니다.");
        }
        memberRepository.activateDormantAccount(memberId);
        emailVerificationService.removeVerification(memberEmail);
    }

    // 2. 탈퇴 취소 (복구)
    @Transactional
    public void cancelDeleteMember(String memberId, String memberEmail) {
        if (!emailVerificationService.isVerified(memberEmail)) {
            throw new IllegalStateException("이메일 인증이 완료되지 않았습니다.");
        }
        memberRepository.cancelDeleteMember(memberId);
        emailVerificationService.removeVerification(memberEmail);
    }
}