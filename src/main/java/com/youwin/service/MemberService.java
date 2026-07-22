package com.youwin.service;

import com.youwin.dto.LoginRequestDto;
import com.youwin.dto.MemberDto;
import com.youwin.repository.MemberRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Service
public class MemberService {

    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;

    public MemberService(MemberRepository memberRepository, PasswordEncoder passwordEncoder) {
        this.memberRepository = memberRepository;
        this.passwordEncoder = passwordEncoder;
    }

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
}