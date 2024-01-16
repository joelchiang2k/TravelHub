package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.synex.domain.HotelRoom;

@Service
public interface HotelRoomService {
	public Optional<HotelRoom> findById(Integer typeId);
    public List<HotelRoom> findAll();
}
