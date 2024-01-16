package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.synex.domain.RoomType;
import com.synex.repository.RoomTypeRepository;

@Service
public class RoomTypeServiceImpl implements RoomTypeService {
	
	@Autowired RoomTypeRepository roomTypeRepository;
	
	@Override
	public Optional<RoomType> findById(Integer typeId) {
		// TODO Auto-generated method stub
		return roomTypeRepository.findById(typeId);
	}

	@Override
	public List<RoomType> findAll() {
		// TODO Auto-generated method stub
		return roomTypeRepository.findAll();
	}

}
