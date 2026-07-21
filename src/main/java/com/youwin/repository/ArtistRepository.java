package com.youwin.repository;

import com.youwin.dto.ArtistDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ArtistRepository {
    List<ArtistDto> findAll();

    List<ArtistDto> search(String keyword);

    ArtistDto findById(Integer artistId);
}
