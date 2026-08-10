package com.youwin.api;

import com.youwin.service.EmailVerificationService;
import com.youwin.service.MemberService;
import com.youwin.service.MemberService.AccountRestoreType;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;
    private final EmailVerificationService emailVerificationService;

    /* ================= 중복 체크 API ================= */

    @GetMapping("/check-id")
    public boolean checkDuplicateId(@RequestParam("memberId") String memberId) {
        return memberService.isIdDuplicate(memberId);
    }

    @GetMapping("/check-nickname")
    public boolean checkDuplicateNickname(@RequestParam("nickname") String nickname) {
        return memberService.isNicknameDuplicate(nickname);
    }

    @GetMapping("/check-email")
    public boolean checkDuplicateEmail(@RequestParam("memberEmail") String memberEmail) {
        return memberService.isEmailDuplicate(memberEmail);
    }

    /* ================= 이메일 인증 공통 API ================= */

    // 1. 단순 이메일 인증번호 발송 (회원가입 등)
    @PostMapping("/send-code")
    public ResponseEntity<?> sendVerificationCode(@RequestBody Map<String, String> request) {
        String email = request.get("memberEmail");
        try {
            emailVerificationService.sendVerificationCode(email);
            return ResponseEntity.ok(Map.of("success", true, "message", "인증번호가 발송되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "메일 발송에 실패했습니다."));
        }
    }

    // 2. 인증번호 검증 API
    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyCode(@RequestBody Map<String, String> request) {
        String email = request.get("memberEmail");
        String code = request.get("code");

        try {
            boolean isMatched = emailVerificationService.verifyCode(email, code);
            if (isMatched) {
                return ResponseEntity.ok(Map.of("success", true, "message", "인증에 성공하였습니다."));
            }
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "인증번호가 일치하지 않습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /* ================= 아이디 / 비밀번호 찾기 API ================= */

    // 아이디 찾기용 인증번호 발송
    @PostMapping("/find-id/send-code")
    public ResponseEntity<?> sendCodeForFindId(@RequestBody Map<String, String> request) {
        try {
            memberService.sendCodeForFindId(request.get("memberName"), request.get("memberEmail"));
            return ResponseEntity.ok(Map.of("success", true, "message", "인증번호가 발송되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 아이디 최종 조회
    @PostMapping("/find-id")
    public ResponseEntity<?> findId(@RequestBody Map<String, String> request) {
        try {
            String memberId = memberService.findMemberId(request.get("memberName"), request.get("memberEmail"));
            return ResponseEntity.ok(Map.of("success", true, "memberId", memberId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 비밀번호 찾기용 인증번호 발송
    @PostMapping("/find-pw/send-code")
    public ResponseEntity<?> sendCodeForFindPw(@RequestBody Map<String, String> request) {
        try {
            memberService.sendCodeForFindPw(request.get("memberId"), request.get("memberEmail"));
            return ResponseEntity.ok(Map.of("success", true, "message", "인증번호가 발송되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 비밀번호 재설정
    @PostMapping("/reset-pw")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> request) {
        try {
            memberService.resetPassword(request.get("memberId"), request.get("memberEmail"), request.get("newPassword"));
            return ResponseEntity.ok(Map.of("success", true, "message", "비밀번호가 성공적으로 변경되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    /* ================= 계정 복구 / 휴면 해제 API ================= */

    // [복구/휴면 공통] 인증번호 발송
    @PostMapping("/send-recovery-code")
    public ResponseEntity<?> sendRecoveryCode(@RequestBody Map<String, String> request) {
        return sendVerificationCode(request); // 기존 sendVerificationCode 재활용
    }

    // 휴면 계정 해제
    @PostMapping("/unlockDormant")
    public ResponseEntity<String> unlockDormant(@RequestBody Map<String, String> request, HttpSession session) {
        return processAccountRestore(request, session, "unlockMemberId", "unlockMemberEmail", AccountRestoreType.DORMANT);
    }

    // 탈퇴 유예 계정 복구
    @PostMapping("/restoreAccount")
    public ResponseEntity<String> restoreAccount(@RequestBody Map<String, String> request, HttpSession session) {
        return processAccountRestore(request, session, "restoreMemberId", "restoreMemberEmail", AccountRestoreType.RESTORE_DELETE);
    }

    // [보조 메서드] 휴면해제 & 탈퇴복구 공통 루틴 처리
    private ResponseEntity<String> processAccountRestore(
            Map<String, String> request,
            HttpSession session,
            String sessionKeyId,
            String sessionKeyEmail,
            AccountRestoreType restoreType
    ) {
        String code = request.get("code");
        String memberId = (String) session.getAttribute(sessionKeyId);
        String memberEmail = (String) session.getAttribute(sessionKeyEmail);

        if (memberId == null || memberEmail == null) {
            return ResponseEntity.ok("EXPIRED");
        }

        try {
            boolean isCodeValid = emailVerificationService.verifyCode(memberEmail, code);
            if (isCodeValid) {
                memberService.restoreAccountStatus(memberId, memberEmail, restoreType);
                session.removeAttribute(sessionKeyId);
                session.removeAttribute(sessionKeyEmail);
                return ResponseEntity.ok("SUCCESS");
            }
            return ResponseEntity.ok("FAIL");
        } catch (Exception e) {
            return ResponseEntity.ok("FAIL");
        }
    }
}