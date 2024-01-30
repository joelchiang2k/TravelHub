package com.synex.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.synex.domain.Booking;
import com.synex.domain.Guest;

@Service
public interface GuestService {
	public Guest save(Guest guest);
    public Guest findById(Integer guestId);
    public List<Guest> findAll();
    public void deleteById(Integer guestId);
    boolean existsById(Integer guestId);
}
