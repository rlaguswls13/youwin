package com.youwin.controller;

import com.youwin.repository.MemberSecurityRepository;
import com.youwin.security.LoginAttemptService;
import com.youwin.security.LoginUnlockTokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequiredArgsConstructor
public class AccountUnlockController {

    private final LoginUnlockTokenService unlockTokenService;
    private final LoginAttemptService loginAttemptService;
    private final MemberSecurityRepository memberSecurityRepository;

    @GetMapping("/member/unlock-account")
    public String unlockAccount(@RequestParam("token") String token, RedirectAttributes redirectAttributes) {

        // 1. 토큰 유효성 및 memberId 확인
        String memberId = unlockTokenService.getMemberIdByToken(token);

        if (memberId == null) {
            // 토큰이 만료되었거나 존재하지 않는 경우
            String errorMsg = URLEncoder.encode("만료되었거나 유효하지 않은 해제 링크입니다. 다시 시도해 주세요.", StandardCharsets.UTF_8);
            return "redirect:/auth/login?error=true&exception=" + errorMsg;
        }

        // 2. DB 상태 원상 복구 (LOCKED/DORMANT -> ACTIVE)
        memberSecurityRepository.unlockAccount(memberId);

        // 3. Caffeine Cache에 남아있는 실패 카운트 및 차단 기록 삭제
        loginAttemptService.loginSucceeded(memberId);

        // 4. 사용한 토큰 즉시 폐기
        unlockTokenService.invalidateToken(token);

        // 5. 성공 메시지 전달 및 로그인 페이지 이동
        String successMsg = URLEncoder.encode("계정 잠금이 성공적으로 해제되었습니다. 다시 로그인해 주세요.", StandardCharsets.UTF_8);
        return "redirect:/auth/login?error=true&exception=" + successMsg;
    }
}