package com.youwin.khs.member.service;

import com.youwin.khs.member.dto.MemberDto;
import com.youwin.khs.member.mapper.MemberMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Service // 🌟 스프링에게 "내가 진짜 비즈니스 로직을 처리하는 핵심 일꾼이야"라고 등록하는 표식
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberMapper memberMapper; // 아까 만든 주소록(Mapper)을 가져옵니다.

    // 🌟 프로필 사진이 진짜로 저장될 서버 컴퓨터의 폴더 경로입니다.
    // (테스트용으로 C드라이브 밑에 upload/profile 폴더를 기준으로 잡을게요!)
    private final String uploadPath = "C:/upload/profile/";

    @Override
    public void join(MemberDto memberDto, MultipartFile profileImage) throws IOException {

        // -----------------------------------------------------------------
        // [1] 임시 비밀번호 암호화 구역 (시큐리티 설정 전이라면 일단 통과하거나 나중에 결합)
        // -----------------------------------------------------------------
        // 지금은 프로필 이미지 저장이 핵심이니 암호화는 기본 텍스트로 가고, 이미지 처리에 집중할게요!

        // -----------------------------------------------------------------
        // [2] 핵심: 프로필 사진 업로드 처리
        // -----------------------------------------------------------------
        // 사용자가 사진을 진짜로 올렸는지 검사합니다 (비어있지 않다면 코드가 작동해요)
        if (profileImage != null && !profileImage.isEmpty()) {

            // 1. 저장할 폴더(C:/upload/profile/)가 컴퓨터에 없으면 자동으로 새로 만듭니다.
            File saveDir = new File(uploadPath);
            if (!saveDir.exists()) {
                saveDir.mkdirs();
            }

            // 2. 파일명 중복 방지 마법!
            // 여러 사람이 'me.jpg'라는 이름으로 올리면 파일이 덮어써지니까
            // UUID(랜덤문자열)를 사용해서 세상에 단 하나뿐인 고유한 이름을 만들어 줍니다.
            String originalFilename = profileImage.getOriginalFilename(); // 원래 파일명 (예: cat.jpg)
            String ext = originalFilename.substring(originalFilename.lastIndexOf(".")); // 확장자 추출 (예: .jpg)
            String savedFilename = UUID.randomUUID().toString() + ext; // 변환된 고유 파일명 (예: a1b2c3d4-....jpg)

            // 3. 지정한 폴더에 뼈대를 잡고, 텅 빈 파일 객체를 만듭니다.
            File targetFile = new File(uploadPath, savedFilename);

            // 4. 스프링이 들고 있던 진짜 이미지 바이너리 파일을 방금 만든 하드디스크 빈 파일 속으로 쏙 복사합니다!
            profileImage.transferTo(targetFile);

            // 5. 🌟 오늘의 주인공: 파일 전체 경로가 아니라 '바뀐 파일명(주소)'을 DTO 상자에 적어줍니다.
            // 나중에 화면에서 꺼내 쓸 때 이 파일명만 있으면 이미지 태그로 띄울 수 있거든요!
            memberDto.setProfileImage(savedFilename);
        }

        // -----------------------------------------------------------------
        // [3] 영양가 있게 채워진 DTO 상자를 들고 창고 관리자(Mapper)에게 던지기
        // -----------------------------------------------------------------
        memberMapper.insertMember(memberDto);
    }

    @Override
    public boolean isMemberIdCheck(String memberId) {
        // 아까 Mapper를 int로 두셨다면 결과가 0보다 큰지 비교하고,
        // boolean으로 바꾸셨다면 그냥 memberMapper.checkId(memberId)를 리턴하시면 됩니다!
        return memberMapper.checkId(memberId) > 0;
    }
}
