package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.synex.domain.Booking;
import com.synex.repository.BookingRepository;

@Service
public class BookingServiceImpl implements BookingService {
	
	@Autowired BookingRepository bookingRepository;
	
	@Override
	public Booking save(Booking booking) {
		// TODO Auto-generated method stub
		return bookingRepository.save(booking);
	}

	@Override
	public Booking findById(Integer bookingId) {
		Optional<Booking> optBooking= bookingRepository.findById(bookingId);
		if(optBooking.isPresent()) {
			return optBooking.get();
		}
		return null;
	}

	@Override
	public List<Booking> findAll() {
		// TODO Auto-generated method stub
		return bookingRepository.findAll();
	}

	@Override
	public void deleteById(Integer bookingId) {
		// TODO Auto-generated method stub
		bookingRepository.deleteById(bookingId);
	}

	@Override
	public boolean existsById(Integer bookingId) {
		// TODO Auto-generated method stub
		return bookingRepository.existsById(bookingId);
	}
	
	@Override
	public int getNextUserId() {
		Integer maxBookingId = bookingRepository.findMaxBookingId();
		return (maxBookingId != null) ? maxBookingId + 1 : 1;
	}
	


}
