package com.youwin.khs.common.util;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class SavedFile {
    private final String originalName; // 원본파일명
    private final String saveName;     // UUID로 저장된 파일명
    private final String path;         // 화면에서 접근할 웹 경로
}
