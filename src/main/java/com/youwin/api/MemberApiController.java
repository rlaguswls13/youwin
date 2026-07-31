package com.youwin.api;

import com.youwin.service.EmailVerificationService;
import com.youwin.service.MemberService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;
    private final EmailVerificationService emailVerificationService;

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

    // 1. 이메일 인증번호 발송 API
    @PostMapping("/send-code")
    public ResponseEntity<?> sendVerificationCode(@RequestBody Map<String, String> request) {
        String email = request.get("memberEmail");
        try {
            emailVerificationService.sendVerificationCode(email);
            return ResponseEntity.ok().body(Map.of("success", true, "message", "인증번호가 발송되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "메일 발송에 실패했습니다."));
        }
    }

    // 2. 이메일 인증번호 대조/확인 API
    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyCode(@RequestBody Map<String, String> request) {
        String email = request.get("memberEmail");
        String code = request.get("code");

        try {
            boolean isMatched = emailVerificationService.verifyCode(email, code);
            if (isMatched) {
                return ResponseEntity.ok().body(Map.of("success", true, "message", "인증에 성공하였습니다."));
            } else {
                return ResponseEntity.badRequest().body(Map.of("success", false, "message", "인증번호가 일치하지 않습니다."));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 1. 아이디 찾기용 이메일 인증번호 발송 요청
    @PostMapping("/find-id/send-code")
    public ResponseEntity<?> sendCodeForFindId(@RequestBody Map<String, String> request) {
        String name = request.get("memberName");
        String email = request.get("memberEmail");

        // DB에 해당 이름+이메일을 가진 회원이 존재하는지 boolean으로 먼저 확인!
        if (!memberService.existsByNameAndEmail(name, email)) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "일치하는 회원 정보가 없습니다."));
        }

        // 존재하면 인증번호 발송
        emailVerificationService.sendVerificationCode(email);
        return ResponseEntity.ok(Map.of("success", true, "message", "인증번호가 발송되었습니다."));
    }

    // 2. 이메일 인증 완료 후 최종 아이디 찾기 요청
    @PostMapping("/find-id")
    public ResponseEntity<?> findId(@RequestBody Map<String, String> request) {
        String name = request.get("memberName");
        String email = request.get("memberEmail");

        try {
            String memberId = memberService.findMemberId(name, email);
            return ResponseEntity.ok(Map.of("success", true, "memberId", memberId));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 1. 비밀번호 찾기용 인증번호 발송 (아이디 + 이메일 검증)
    @PostMapping("/find-pw/send-code")
    public ResponseEntity<?> sendCodeForFindPw(@RequestBody Map<String, String> request) {
        String memberId = request.get("memberId");
        String memberEmail = request.get("memberEmail");

        if (!memberService.existsByIdAndEmail(memberId, memberEmail)) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "일치하는 회원 정보가 없습니다."));
        }

        emailVerificationService.sendVerificationCode(memberEmail);
        return ResponseEntity.ok(Map.of("success", true, "message", "인증번호가 발송되었습니다."));
    }

    // 2. 비밀번호 재설정 요청
    @PostMapping("/reset-pw")
    public ResponseEntity<?> resetPassword(@RequestBody Map<String, String> request) {
        String memberId = request.get("memberId");
        String memberEmail = request.get("memberEmail");
        String newPassword = request.get("newPassword");

        try {
            memberService.updatePassword(memberId, memberEmail, newPassword);
            return ResponseEntity.ok(Map.of("success", true, "message", "비밀번호가 성공적으로 변경되었습니다."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    // 1. [공통] 복구/휴면해제 인증번호 발송 API
    @PostMapping("/send-recovery-code")
    public ResponseEntity<Map<String, Object>> sendRecoveryCode(@RequestBody Map<String, String> request) {
        Map<String, Object> result = new HashMap<>();
        String email = request.get("memberEmail");

        try {
            // EmailVerificationService의 발송 메서드 직접 호출
            emailVerificationService.sendVerificationCode(email);
            result.put("success", true);
            result.put("message", "인증번호가 발송되었습니다.");
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "인증번호 발송에 실패했습니다.");
            return ResponseEntity.badRequest().body(result);
        }
    }

    // 2. 휴면 계정 해제 처리 API
    @PostMapping("/unlockDormant")
    public ResponseEntity<String> unlockDormant(@RequestBody Map<String, String> request, HttpSession session) {
        String code = request.get("code");
        String memberId = (String) session.getAttribute("unlockMemberId");
        String memberEmail = (String) session.getAttribute("unlockMemberEmail");

        if (memberId == null || memberEmail == null) {
            return ResponseEntity.ok("EXPIRED"); // 세션 만료
        }

        try {
            // 1) 인증번호 검증
            boolean isCodeValid = emailVerificationService.verifyCode(memberEmail, code);

            if (isCodeValid) {
                // 2) 휴면 해제 실행 (DB ACTIVE 전환 + 인증데이터 삭제)
                memberService.activateDormantAccount(memberId, memberEmail);

                // 세션 정리
                session.removeAttribute("unlockMemberId");
                session.removeAttribute("unlockMemberEmail");
                return ResponseEntity.ok("SUCCESS");
            } else {
                return ResponseEntity.ok("FAIL"); // 인증번호 불일치
            }
        } catch (Exception e) {
            return ResponseEntity.ok("FAIL");
        }
    }

    // 3. 탈퇴 유예 계정 복구 처리 API
    @PostMapping("/restoreAccount")
    public ResponseEntity<String> restoreAccount(@RequestBody Map<String, String> request, HttpSession session) {
        String code = request.get("code");
        String memberId = (String) session.getAttribute("restoreMemberId");
        String memberEmail = (String) session.getAttribute("restoreMemberEmail");

        if (memberId == null || memberEmail == null) {
            return ResponseEntity.ok("EXPIRED"); // 세션 만료
        }

        try {
            // 1) 인증번호 검증
            boolean isCodeValid = emailVerificationService.verifyCode(memberEmail, code);

            if (isCodeValid) {
                // 2) 탈퇴 복구 실행 (DB ACTIVE 전환, deleted_at=NULL + 인증데이터 삭제)
                memberService.cancelDeleteMember(memberId, memberEmail);

                // 세션 정리
                session.removeAttribute("restoreMemberId");
                session.removeAttribute("restoreMemberEmail");
                return ResponseEntity.ok("SUCCESS");
            } else {
                return ResponseEntity.ok("FAIL"); // 인증번호 불일치
            }
        } catch (Exception e) {
            return ResponseEntity.ok("FAIL");
        }
    }
}