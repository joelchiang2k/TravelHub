package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.synex.domain.HotelRoom;
import com.synex.repository.HotelRoomRepository;

@Service
public class HotelRoomServiceImpl implements HotelRoomService {
	
	@Autowired HotelRoomRepository hotelRoomRepository;
	
	@Override
	public Optional<HotelRoom> findById(Integer hotelRoomId) {
		// TODO Auto-generated method stub
		return hotelRoomRepository.findById(hotelRoomId);
	}

	@Override
	public List<HotelRoom> findAll() {
		// TODO Auto-generated method stub
		return hotelRoomRepository.findAll();
	}

}
