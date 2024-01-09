package com.synex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.synex.domain.Hotel;
import com.synex.service.HotelService;

@RestController
public class HotelController {
	@Autowired HotelService hotelService;
	@RequestMapping(value = "/searchHotel/{searchString}")
	public List<Hotel> searchHotel(@PathVariable String searchString){
		System.out.println("name:" + searchString);
		System.out.println("hotels:" + hotelService.searchHotel(searchString));
		return hotelService.searchHotel(searchString);
	}
	
	@RequestMapping(value = "/all")
	public List<Hotel> findAllHotel(){
		//System.out.println("hotels" + hotelService.findAllHotel());
		return hotelService.findAllHotel();
	}
}
