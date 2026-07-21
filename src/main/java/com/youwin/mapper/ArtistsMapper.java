package com.youwin.mapper;


import com.youwin.dto.ArtistDto;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ArtistsMapper {

    // 아티스트 목록 조회
    List<ArtistDto> findAllArtists();

    // 아티스트 검색
    List<ArtistDto> searchArtists(String keyword);

    // 아티스트 상세조회
    ArtistDto findArtistById(Integer artistId);
}
