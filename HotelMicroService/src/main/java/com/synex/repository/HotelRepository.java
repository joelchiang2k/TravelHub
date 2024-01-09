package com.synex.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.synex.domain.Hotel;

public interface HotelRepository extends JpaRepository<Hotel, Integer>{
	public List<Hotel> findByHotelNameLikeOrAddressLikeOrCityLikeOrStateLike(String hotelName, String address, String city, String state);
}