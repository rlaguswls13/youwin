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
        String projectPath = System.getProperty("user.dir");

        // src/main/resources/static/upload/ 경로로 매핑
        String normalizedPath = projectPath.replace("\\", "/");
        String uploadPath = "file:///" + normalizedPath + "/src/main/resources/static/upload/";

        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}