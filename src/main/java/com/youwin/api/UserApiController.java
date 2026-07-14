package com.youwin.api;

import com.youwin.api.dto.UserListResponse;
import com.youwin.mapper.AppUserMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/users")
public class UserApiController {

    private final AppUserMapper appUserMapper;

    public UserApiController(AppUserMapper appUserMapper) {
        this.appUserMapper = appUserMapper;
    }

    @GetMapping
    public UserListResponse findUsers() {
        return new UserListResponse(appUserMapper.findAll(), appUserMapper.count());
    }
}