package com.youwin.service;

import com.youwin.dto.AutoLoginDto;
import com.youwin.dto.MemberDto;
import com.youwin.repository.AutoLoginRepository;
import com.youwin.repository.MemberRepository;
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
@Transactional(readOnly = true)
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
            if (updatedMember != null) {
                updatedMember.setMemberPassword(null); // 보안상 비밀번호 제거
                CustomUserDetails newDetails = new CustomUserDetails(updatedMember);
                UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(
                        newDetails, auth.getCredentials(), newDetails.getAuthorities()
                );
                SecurityContextHolder.getContext().setAuthentication(newAuth);
            }
        }
    }

    /* ================= 1. 회원가입 및 중복확인 ================= */

    @Transactional
    public void joinMember(MemberDto memberDto) {
        validateEmailVerification(memberDto.getMemberEmail());

        memberDto.setMemberPassword(passwordEncoder.encode(memberDto.getMemberPassword()));

        saveProfileImageInternal(memberDto, memberDto.getProfile());

        memberRepository.insertMember(memberDto);

        emailVerificationService.removeVerification(memberDto.getMemberEmail());
    }

    public boolean isIdDuplicate(String memberId) {
        return memberRepository.countByMemberId(memberId) > 0;
    }

    public boolean isNicknameDuplicate(String nickname) {
        return memberRepository.countByNickname(nickname) > 0;
    }

    public boolean isEmailDuplicate(String memberEmail) {
        return memberRepository.countByMemberEmail(memberEmail) > 0;
    }

    /* ================= 2. 아이디 / 비밀번호 찾기 ================= */

    // [수정] Repository의 existsByNameAndEmail 삭제 -> findMemberIdByNameAndEmail 단건 조회로 존재 검증
    public void sendCodeForFindId(String name, String email) {
        String memberId = memberRepository.findMemberIdByNameAndEmail(name, email);
        if (memberId == null) {
            throw new IllegalArgumentException("일치하는 회원 정보가 없습니다.");
        }
        emailVerificationService.sendVerificationCode(email);
    }

    // [수정] Repository의 existsByIdAndEmail 삭제 -> findByMemberId 조회 후 이메일 비교로 존재 검증
    public void sendCodeForFindPw(String memberId, String email) {
        MemberDto member = memberRepository.findByMemberId(memberId);
        if (member == null || !email.equals(member.getMemberEmail())) {
            throw new IllegalArgumentException("일치하는 회원 정보가 없습니다.");
        }
        emailVerificationService.sendVerificationCode(email);
    }

    @Transactional
    public String findMemberId(String memberName, String memberEmail) {
        validateEmailVerification(memberEmail);

        String foundMemberId = memberRepository.findMemberIdByNameAndEmail(memberName, memberEmail);
        if (foundMemberId == null) {
            throw new IllegalArgumentException("일치하는 회원 정보가 없습니다.");
        }

        emailVerificationService.removeVerification(memberEmail);
        return foundMemberId;
    }

    @Transactional
    public void resetPassword(String memberId, String memberEmail, String newPassword) {
        validateEmailVerification(memberEmail);

        String encodedPassword = passwordEncoder.encode(newPassword);
        memberRepository.updatePassword(memberId, encodedPassword);

        emailVerificationService.removeVerification(memberEmail);
    }

    /* ================= 3. 회원 정보 수정 (설정 페이지) ================= */

    // [수정] 개별 쿼리 대신 updateMemberFields 동적 쿼리 사용
    @Transactional
    public void updateNickname(String memberId, String nickname) {
        MemberDto updateDto = new MemberDto();
        updateDto.setMemberId(memberId);
        updateDto.setNickname(nickname);
        memberRepository.updateMemberFields(updateDto);
        refreshSecurityContext(memberId);
    }

    // [수정] 개별 쿼리 대신 updateMemberFields 동적 쿼리 사용
    @Transactional
    public void updatePhone(String memberId, String memberPhone) {
        MemberDto updateDto = new MemberDto();
        updateDto.setMemberId(memberId);
        updateDto.setMemberPhone(memberPhone);
        memberRepository.updateMemberFields(updateDto);
        refreshSecurityContext(memberId);
    }

    // [수정] 개별 쿼리 대신 updateMemberFields 동적 쿼리 사용
    @Transactional
    public void updateEmail(String memberId, String memberEmail) {
        MemberDto updateDto = new MemberDto();
        updateDto.setMemberId(memberId);
        updateDto.setMemberEmail(memberEmail);
        memberRepository.updateMemberFields(updateDto);
        refreshSecurityContext(memberId);
    }

    @Transactional
    public void updatePasswordInSettings(String memberId, String currentPassword, String newPassword) {
        MemberDto member = memberRepository.findByMemberId(memberId);
        if (member == null || !passwordEncoder.matches(currentPassword, member.getMemberPassword())) {
            throw new IllegalArgumentException("현재 비밀번호가 올바르지 않습니다.");
        }

        if (passwordEncoder.matches(newPassword, member.getMemberPassword())) {
            throw new IllegalArgumentException("현재 비밀번호와 동일한 비밀번호로는 변경할 수 없습니다.");
        }

        memberRepository.updatePassword(memberId, passwordEncoder.encode(newPassword));
    }

    // [수정] updateProfileImage 대신 updateMemberFields 동적 쿼리 사용
    @Transactional
    public void updateProfileImage(String memberId, MultipartFile profile, boolean deleteProfile) {
        MemberDto currentMember = memberRepository.findByMemberId(memberId);
        String oldFilePath = currentMember != null ? currentMember.getProfileImage() : null;

        MemberDto updateDto = new MemberDto();
        updateDto.setMemberId(memberId);

        if (deleteProfile) {
            updateDto.setProfileImage(null);
            memberRepository.updateMemberFields(updateDto);
            deletePhysicalFile(oldFilePath);
        } else if (profile != null && !profile.isEmpty()) {
            saveProfileImageInternal(currentMember, profile);
            updateDto.setProfileImage(currentMember.getProfileImage());
            memberRepository.updateMemberFields(updateDto);

            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCompletion(int status) {
                    if (status == STATUS_COMMITTED) {
                        deletePhysicalFile(oldFilePath);
                    }
                }
            });
        }
        refreshSecurityContext(memberId);
    }

    /* ================= 4. 계정 상태 변경 (휴면 / 탈퇴 / 복구) ================= */

    @Transactional
    public void deleteMember(String memberId) {
        memberRepository.deleteMember(memberId);
    }

    @Transactional
    public void updateLastLoginAt(String memberId) {
        memberRepository.updateLastLoginAt(memberId);
    }

    @Transactional
    public void restoreAccountStatus(String memberId, String memberEmail, AccountRestoreType type) {
        validateEmailVerification(memberEmail);

        if (type == AccountRestoreType.DORMANT) {
            memberRepository.activateDormantAccount(memberId);
        } else if (type == AccountRestoreType.RESTORE_DELETE) {
            memberRepository.cancelDeleteMember(memberId);
        }

        emailVerificationService.removeVerification(memberEmail);
    }

    public enum AccountRestoreType {
        DORMANT, RESTORE_DELETE
    }

    /* ================= 5. 자동 로그인 및 보조 메서드 ================= */

    @Transactional
    public void setupAutoLogin(String memberId, HttpServletResponse response) {
        String token = UUID.randomUUID().toString();
        int amount = 60 * 60 * 24 * 7;
        Date limitDate = new Date(System.currentTimeMillis() + ((long) amount * 1000));

        AutoLoginDto autoLoginDto = new AutoLoginDto();
        autoLoginDto.setMemberId(memberId);
        autoLoginDto.setToken(token);
        autoLoginDto.setLimitDate(limitDate);

        autoLoginRepository.upsertToken(autoLoginDto);

        Cookie cookie = new Cookie("remember-me", token);
        cookie.setPath("/");
        cookie.setMaxAge(amount);
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
    }

    @Transactional
    public MemberDto getMemberById(String memberId) {
        MemberDto memberDto = memberRepository.findByMemberId(memberId);
        if (memberDto != null) {
            memberDto.setMemberPassword(null);
        }
        return memberDto;
    }

    @Transactional
    public void removeAutoLoginToken(String token) {
        autoLoginRepository.deleteByToken(token);
    }

    public boolean checkPassword(String memberId, String rawPassword) {
        MemberDto memberDto = memberRepository.findByMemberId(memberId);
        return memberDto != null && passwordEncoder.matches(rawPassword, memberDto.getMemberPassword());
    }

    /* Private Helper Methods */

    private void validateEmailVerification(String email) {
        if (!emailVerificationService.isVerified(email)) {
            throw new IllegalStateException("이메일 인증이 완료되지 않았습니다.");
        }
    }

    private void saveProfileImageInternal(MemberDto dto, MultipartFile profileFile) {
        if (profileFile != null && !profileFile.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            String uploadPath = projectPath + File.separator + "upload" + File.separator + "profile" + File.separator;

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String savedFileName = UUID.randomUUID().toString() + "_" + profileFile.getOriginalFilename();
            File dest = new File(uploadPath, savedFileName);

            try {
                profileFile.transferTo(dest);
                TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                    @Override
                    public void afterCompletion(int status) {
                        if (status == STATUS_ROLLED_BACK && dest.exists()) {
                            dest.delete();
                        }
                    }
                });
                dto.setProfileImage("/upload/profile/" + savedFileName);
            } catch (IOException e) {
                throw new RuntimeException("프로필 이미지 저장 중 오류가 발생했습니다.", e);
            }
        }
    }

    private void deletePhysicalFile(String dbFilePath) {
        if (dbFilePath != null && !dbFilePath.isEmpty()) {
            String projectPath = System.getProperty("user.dir");
            File fileToDelete = new File(projectPath + dbFilePath.replace("/", File.separator));
            if (fileToDelete.exists()) {
                fileToDelete.delete();
            }
        }
    }
}