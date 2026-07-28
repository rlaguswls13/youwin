package com.youwin.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 프로젝트 소스 코드가 없는 외부의 안전한 폴더를 지정합니다. (예시: C:/youwin_upload/)
        // 맥/리눅스 사용자의 경우 "file:///Users/사용자이름/youwin_upload/" 형태로 지정하시면 됩니다.
        String uploadPath = "file:///C:/youwin_upload/";

        // 브라우저의 /upload/** 요청을 외부 실제 하드디스크 경로로 매핑
        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}