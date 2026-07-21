package com.youwin.khs.common.util;

import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Component
public class FileUploadUtil {

    public SavedFile save(MultipartFile file, String uploadDir, String webPrefix) throws IOException {
        if(file == null || file.isEmpty()){
            return null;
        }

        // 1. 원본 파일명 및 확장자 추출
        String originalName = file.getOriginalFilename();
        String ext = "";
        int dotIndex = originalName.lastIndexOf('.');
        if(dotIndex > -1) {
            ext = originalName.substring(dotIndex);
        }

        // 2. 겹치지 않는 고유한 새 이름 생성
        String saveName = UUID.randomUUID() + ext;

        // 3. 하드디스크에 저장할 폴더가 없으면 새로 생성 (버그 수정 버전)
        File dir = new File(uploadDir).getAbsoluteFile();
        if(!dir.exists()){
            dir.mkdirs();
        }

        // 4. 진짜 파일 물리 저장
        File target = new File(dir, saveName);
        file.transferTo(target);

        // 5. 웹 브라우저가 접근할 가상 주소 조립 후 보관증 리턴
        String path = webPrefix + "/" + saveName;
        return new SavedFile(originalName, saveName, path);
    }
}
