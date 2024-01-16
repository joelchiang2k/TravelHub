package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.synex.domain.RoomType;

@Service
public interface RoomTypeService {
    public Optional<RoomType> findById(Integer hotelRoomId);
    public List<RoomType> findAll();
    
}
