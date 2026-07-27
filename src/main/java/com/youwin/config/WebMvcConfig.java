package com.youwin.config;

import com.youwin.interceptor.ActiveUserInterceptor; // ★ 추가
import com.youwin.interceptor.AutoLoginInterceptor;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    private final AutoLoginInterceptor autoLoginInterceptor;
    private final ActiveUserInterceptor activeUserInterceptor; // ★ 주입 추가

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 1. 자동 로그인 처리 인터셉터 (모든 경로)
        registry.addInterceptor(autoLoginInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/css/**", "/js/**", "/images/**", "/upload/**", "/error");

        // 2. ACTIVE 회원 전용 페이지 접근 제어 인터셉터 (추가)
        registry.addInterceptor(activeUserInterceptor)
                .addPathPatterns("/member/myPage", "/member/settings") // 보호할 경로 지정
                .excludePathPatterns("/css/**", "/js/**", "/images/**", "/upload/**", "/error");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String projectPath = System.getProperty("user.dir");

        String uploadPath = "file:///" + projectPath + File.separator + "upload" + File.separator;

        registry.addResourceHandler("/upload/**")
                .addResourceLocations(uploadPath);
    }
}