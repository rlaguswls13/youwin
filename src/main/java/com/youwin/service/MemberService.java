package com.youwin.service;

import com.youwin.dto.AutoLoginDto;
import com.youwin.dto.LoginRequestDto;
import com.youwin.dto.MemberDto;
import com.youwin.repository.MemberRepository;
import com.youwin.repository.AutoLoginRepository;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
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

    @Transactional
    public void joinMember(MemberDto memberDto) {
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

    public MemberDto login(LoginRequestDto loginDto) {
        // 1. DB에서 아이디로 회원 정보 전체 조회 (MemberDto)
        MemberDto memberDto = memberRepository.findByMemberId(loginDto.getMemberId());

        // 2. 입력한 아이디에 해당하는 회원이 없는 경우
        if (memberDto == null) {
            throw new IllegalArgumentException("아이디 또는 비밀번호가 일치하지 않습니다.");
        }

        // 3. 비밀번호 검증
        if (!passwordEncoder.matches(loginDto.getMemberPassword(), memberDto.getMemberPassword())) {
            throw new IllegalArgumentException("아이디 또는 비밀번호가 일치하지 않습니다.");
        }

        // 4. 보안을 위해 세션 저장 직전 비밀번호 필드만 null 처리
        memberDto.setMemberPassword(null);

        // 5. 세션에 담아둘 회원 프로필 정보 리턴
        return memberDto;
    }


    @Transactional
    public void setupAutoLogin(String memberId, HttpServletResponse response) {
        String token = UUID.randomUUID().toString();

        int amount = 60 * 60 * 24 * 7;
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

    // [자동 로그인 2] 쿠키의 토큰으로 회원 정보 조회
    public MemberDto getMemberByAutoLoginToken(String token) {
        String memberId = autoLoginRepository.findMemberIdByToken(token);

        if (memberId == null) {
            return null;
        }

        MemberDto memberDto = memberRepository.findByMemberId(memberId);
        if (memberDto != null) {
            memberDto.setMemberPassword(null);
        }
        return memberDto;
    }

    // [자동 로그인 3] 토큰 삭제 (로그아웃 시)
    @Transactional
    public void removeAutoLoginToken(String token) {
        autoLoginRepository.deleteByToken(token);
    }

    // 아이디 찾기
    public String findMemberId(String memberName, String memberEmail) {
        String foundMemberId = memberRepository.findMemberIdByNameAndEmail(memberName, memberEmail);

        if (foundMemberId == null) {
            throw new IllegalArgumentException("일치하는 회원 정보가 없습니다.");
        }

        return foundMemberId;
    }

    // 1. 회원 존재 여부 검증
    public boolean checkMemberExist(String memberId, String memberEmail) {
        int count = memberRepository.countByMemberIdAndEmail(memberId, memberEmail);
        if (count == 0) {
            throw new IllegalArgumentException("입력하신 아이디와 이메일 정보가 일치하지 않습니다.");
        }
        return true;
    }

    // 2. 새 비밀번호를 BCrypt로 암호화 후 DB에 UPDATE
    public void updatePassword(String memberId, String newPassword) {
        // BCrypt 암호화
        String encodedPassword = passwordEncoder.encode(newPassword);

        // DB 업데이트
        memberRepository.updatePassword(memberId, encodedPassword);
    }
}