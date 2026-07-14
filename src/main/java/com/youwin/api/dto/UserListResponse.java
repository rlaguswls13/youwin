package com.youwin.api.dto;

import com.youwin.mapper.dto.AppUser;

import java.util.List;

public record UserListResponse(List<AppUser> users, long totalCount) {
}