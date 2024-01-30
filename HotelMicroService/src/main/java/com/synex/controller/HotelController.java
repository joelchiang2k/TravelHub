package com.synex.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.synex.domain.Hotel;
import com.synex.domain.HotelRoom;
import com.synex.domain.RoomType;
import com.synex.repository.HotelRepository;
import com.synex.service.HotelRoomService;
import com.synex.service.HotelService;
import com.synex.service.RoomTypeService;

@RestController
public class HotelController {
	@Autowired HotelService hotelService;
	@Autowired RoomTypeService roomTypeService;
	@Autowired HotelRoomService hotelRoomService;
	
	@RequestMapping(value = "/searchHotel/{searchString}")
	public List<Hotel> searchHotel(@PathVariable String searchString){
		System.out.println("name:" + searchString);
		System.out.println("hotels:" + hotelService.searchHotel(searchString));
		return hotelService.searchHotel(searchString);
	}
	
	@RequestMapping(value = "/allHotels")
	public List<Hotel> findAllHotel(){
		//System.out.println("hotels" + hotelService.findAllHotel());
		return hotelService.findAllHotel();
	}
	
	@RequestMapping(value = "/getRoomTypes")
	@CrossOrigin(origins = "http://localhost:8282")
	public List<RoomType> findRoomTypes(){
		return roomTypeService.findAll();
	}
	@RequestMapping(value="/hotel/{hotelId}")
	public Optional<Hotel> findHotel(@PathVariable int hotelId) {
		return hotelService.findHotel(hotelId);
	}
	
	@RequestMapping(value = "/getHotelRoomDetails")
	@CrossOrigin(origins = "http://localhost:8282")
	public List<HotelRoom> findHotelDetails(){
		System.out.println("Reached");
		return hotelRoomService.findAll();
	}
	
	
	
}
