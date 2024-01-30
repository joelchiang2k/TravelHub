package com.synex.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.JsonNode;
import com.synex.domain.Booking;

@Service
public interface BookingService {
	
	public Booking save(Booking booking);
    public Booking findById(Integer bookingId);
    public List<Booking> findAll();
    public void deleteById(Integer bookingId);
    boolean existsById(Integer bookingId);
    public int getNextUserId();
}
