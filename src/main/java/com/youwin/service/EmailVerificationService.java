package com.youwin.service;

import com.youwin.repository.EmailVerificationRepository; // 사용 중이신 Repository/Mapper 경로에 맞춰 변경
import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class EmailVerificationService {

    private final JavaMailSender mailSender;
    private final EmailVerificationRepository emailVerificationRepository;

    // 6자리 랜덤 인증번호 생성
    public String createAuthCode() {
        return String.valueOf((int) (Math.random() * 899999) + 100000);
    }

    // 메일 발송 및 DB 저장 공통 처리
    @Transactional
    public void sendVerificationCode(String email) {
        String authCode = createAuthCode();
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(5); // 5분 유효기간

        // 1. DB에 인증 정보 저장/갱신
        emailVerificationRepository.saveVerificationCode(email, authCode, expiresAt);

        // 2. 이메일 발송
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("[YouWin] 이메일 인증번호 안내");
        message.setText("안녕하세요.\n요청하신 인증번호는 [" + authCode + "] 입니다.\n5분 이내에 입력해주세요.");

        mailSender.send(message);
    }

    // 인증번호 검증 공통 처리
    @Transactional
    public boolean verifyCode(String email, String inputCode) {
        // 1. 해당 이메일의 최신 인증 정보 조회
        // (Repository 메서드는 프로젝트 상황에 맞게 매핑)
        var verification = emailVerificationRepository.findLatestByEmail(email);

        if (verification == null) {
            throw new IllegalArgumentException("인증번호가 요청되지 않았거나 만료되었습니다.");
        }

        if (verification.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new IllegalStateException("인증번호 유효시간(5분)이 초과되었습니다. 재발송 해주세요.");
        }

        if (!verification.getCode().equals(inputCode)) {
            return false; // 인증번호 불일치
        }

        // 2. 인증 완료 상태로 변경
        emailVerificationRepository.updateVerifiedStatus(email, true);
        return true;
    }

    // 인증 완료 여부 확인 (최종 회원가입/비밀번호 변경 직전에 확인용)
    public boolean isVerified(String email) {
        return emailVerificationRepository.isVerified(email);
    }

    // 사용 완료된 인증 데이터 삭제
    @Transactional
    public void removeVerification(String email) {
        emailVerificationRepository.deleteByEmail(email);
    }
}