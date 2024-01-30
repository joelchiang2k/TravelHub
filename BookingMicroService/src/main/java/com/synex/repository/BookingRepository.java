package com.synex.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.synex.domain.Booking;

public interface BookingRepository extends JpaRepository<Booking, Integer> {
	@Query("SELECT MAX(b.bookingId) FROM Booking b")
	Integer findMaxBookingId();
}
