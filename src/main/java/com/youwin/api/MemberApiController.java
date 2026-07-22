package com.youwin.api;


import com.youwin.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController // @Controller + @ResponseBody 합친 것 (JSON 반환 전용)
@RequestMapping("/api/member")
@RequiredArgsConstructor
public class MemberApiController {

    private final MemberService memberService;

    @GetMapping("/check-id")
    public boolean checkDuplicateId(@RequestParam("memberId") String memberId) {
        return memberService.isIdDuplicate(memberId);
    }

    @GetMapping("/check-nickname")
    public boolean checkDuplicateNickname(@RequestParam("nickname") String nickname) {
        return memberService.isNicknameDuplicate(nickname);
    }
}