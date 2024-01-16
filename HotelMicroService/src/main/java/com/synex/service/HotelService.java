package com.synex.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.synex.domain.Hotel;
import com.synex.repository.HotelRepository;

@Service
public class HotelService {
	@Autowired HotelRepository hotelRepository;
	
	public List<Hotel> searchHotel(String searchString){
		System.out.println("searchString" + searchString);
		searchString = "%"+searchString+"%";
		System.out.println("results: " + hotelRepository.findByHotelNameLikeOrAddressLikeOrCityLikeOrStateLike(searchString, searchString, searchString, searchString));
		return hotelRepository.findByHotelNameLikeOrAddressLikeOrCityLikeOrStateLike(searchString, searchString, searchString, searchString);
	}
	
	public List<Hotel> findAllHotel(){
		return hotelRepository.findAll();
	}

}
