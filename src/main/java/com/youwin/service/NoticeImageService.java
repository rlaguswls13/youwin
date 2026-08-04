package com.youwin.service;

import com.youwin.dto.NoticeImageDto;
import com.youwin.repository.NoticeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@Service
public class NoticeImageService {

    // [수정] WebMvcConfig와 경로를 일치시켜 src/main/resources/static/upload/ 에 저장되도록 동적 경로 설정
    private final String uploadPath = System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/static/upload/";
    private final NoticeRepository noticeRepository;

    @Autowired
    public NoticeImageService(NoticeRepository noticeRepository) {
        this.noticeRepository = noticeRepository;
    }

    /**
     * 1. 다중 이미지 파일 업로드 및 DB 기록
     */
    @Transactional
    public void saveImages(Long noticeId, List<MultipartFile> files) {
        if (files == null || files.isEmpty()) return;

        File dir = new File(uploadPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        for (MultipartFile file : files) {
            if (file == null || file.isEmpty() || file.getSize() <= 0) {
                continue;
            }

            String originalName = file.getOriginalFilename();
            if (originalName == null || originalName.trim().isEmpty()) {
                continue;
            }

            String lowerName = originalName.toLowerCase();
            if (lowerName.startsWith("http://") || lowerName.startsWith("https://") || lowerName.startsWith("blob:") || lowerName.contains("localhost")) {
                continue;
            }

            int lastIdx = originalName.lastIndexOf(".");
            if (lastIdx == -1) continue;

            String uuid = UUID.randomUUID().toString();
            String ext = originalName.substring(lastIdx);
            String savedFileName = uuid + ext;

            File saveFile = new File(uploadPath, savedFileName);

            try {
                try (InputStream inputStream = file.getInputStream()) {
                    Files.copy(inputStream, saveFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            } catch (IOException e) {
                throw new RuntimeException("파일 업로드 중 오류 발생: " + originalName, e);
            }

            NoticeImageDto imageDto = new NoticeImageDto();
            imageDto.setNoticeId(noticeId);
            imageDto.setOriginalName(originalName);
            imageDto.setSavedFileName(savedFileName);

            noticeRepository.insertImage(imageDto);
        }
    }

    @Transactional(readOnly = true)
    public List<NoticeImageDto> getImagesByNoticeId(Long noticeId) {
        return noticeRepository.selectImagesByNoticeId(noticeId);
    }

    /**
     * 4. 수정 시 이미지 동기화 처리 (중복 저장 방어 적용)
     */
    @Transactional
    public void updateBoardImages(Long noticeId, MultipartFile[] files, List<String> existingFiles) {
        // 1. 현재 DB에 저장되어 있는 해당 글의 이미지 목록 조회
        List<NoticeImageDto> dbImages = noticeRepository.selectImagesByNoticeId(noticeId);

        // 2. 클라이언트가 유지하겠다고 보낸 기존 파일 목록(existingFiles)에 없는 이미지들은 삭제 처리
        for (NoticeImageDto dbImage : dbImages) {
            boolean isKept = false;
            if (existingFiles != null) {
                for (String existingUrl : existingFiles) {
                    // URL에 해당 파일명이 포함되어 있다면 유지 대상으로 판단
                    if (existingUrl.contains(dbImage.getSavedFileName())) {
                        isKept = true;
                        break;
                    }
                }
            }

            // 유지 대상이 아니라면 물리 파일 삭제 및 DB 레코드 삭제
            if (!isKept) {
                File file = new File(uploadPath, dbImage.getSavedFileName());
                if (file.exists()) {
                    file.delete();
                }
                noticeRepository.deleteImageById(dbImage.getImageId());
            }
        }

        // 3. 새로 추가된 파일(MultipartFile)들만 골라서 안전하게 저장
        if (files != null && files.length > 0) {
            List<MultipartFile> validNewFiles = new java.util.ArrayList<>();
            for (MultipartFile file : files) {
                if (file != null && !file.isEmpty() && file.getSize() > 0) {
                    String origName = file.getOriginalFilename();
                    if (origName != null && !origName.toLowerCase().startsWith("http") && !origName.toLowerCase().startsWith("blob")) {
                        validNewFiles.add(file);
                    }
                }
            }

            if (!validNewFiles.isEmpty()) {
                saveImages(noticeId, validNewFiles);
            }
        }
    }

    @Transactional
    public void deleteImagesByNoticeId(Long noticeId) {
        List<NoticeImageDto> images = noticeRepository.selectImagesByNoticeId(noticeId);

        if (images != null && !images.isEmpty()) {
            for (NoticeImageDto image : images) {
                if (image.getSavedFileName() != null) {
                    File file = new File(uploadPath, image.getSavedFileName());
                    if (file.exists()) {
                        file.delete();
                    }
                }
            }
            noticeRepository.deleteImagesByNoticeId(noticeId);
        }
    }
}