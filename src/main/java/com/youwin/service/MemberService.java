package com.youwin.service;

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
}