package com.youwin.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 프로젝트 루트 경로를 가져와 외부 업로드 폴더 또는 정적 리소스 경로 매핑
        String projectPath = System.getProperty("user.dir");
        String normalizedPath = projectPath.replace("\\", "/");

        // 운영체제 및 파일 시스템 경로 규칙에 맞춘 리소스 로케이션 설정
        String uploadPath = "file:///" + normalizedPath + "/src/main/resources/static/upload/";

        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}