package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.synex.domain.Booking;
import com.synex.domain.Guest;
import com.synex.repository.GuestRepository;

@Service
public class GuestServiceImpl implements GuestService {
	
	@Autowired GuestRepository guestRepository;
	
	@Override
	public Guest save(Guest guest) {
		// TODO Auto-generated method stub
		return guestRepository.save(guest);
	}

	@Override
	public Guest findById(Integer guestId) {
		Optional<Guest> optGuest = guestRepository.findById(guestId);
		if(optGuest.isPresent()) {
			return optGuest.get();
		}
		return null;
	}

	@Override
	public List<Guest> findAll() {
		// TODO Auto-generated method stub
		return guestRepository.findAll();
	}

	@Override
	public void deleteById(Integer guestId) {
		// TODO Auto-generated method stub
		guestRepository.deleteById(guestId);
	}

	@Override
	public boolean existsById(Integer guestId) {
		// TODO Auto-generated method stub
		return guestRepository.existsById(guestId);
	}

}
