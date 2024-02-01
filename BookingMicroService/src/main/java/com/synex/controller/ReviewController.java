package com.synex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.synex.domain.Booking;
import com.synex.domain.Guest;
import com.synex.domain.Review;
import com.synex.repository.GuestRepository;
import com.synex.service.BookingService;
import com.synex.service.GuestService;
import com.synex.service.ReviewService;

@RestController
public class ReviewController {
	@Autowired ReviewService reviewService;
	@Autowired BookingService bookingService;
//    @RequestMapping(value = "saveReview", method = RequestMethod.POST)
//    @CrossOrigin(origins = "http://localhost:8282")
//    public Review saveReview(@RequestBody Review review) {
//    	System.out.println("Reviewcontroller" + review);
//    	return reviewService.save(review);
//    }
	@PostMapping("/saveReview")
	@CrossOrigin(origins = "http://localhost:8282")
    public ResponseEntity<String> saveReview(@RequestBody Review review) {
        // Your logic to save the review
		Booking booking = bookingService.findById(review.getBookingId());
		review.setBooking(booking);
		System.out.println("hotelId" + booking.getHotelId());
		review.setHotelId(booking.getHotelId());
		var amenitiesRating = review.getAmenitiesRating();
		var bookingProcessRating = review.getBookingProcessRating();
		var wholeExpRating = review.getWholeExpRating();
		var serviceRating = review.getServiceRating();
		
		var overallRating = (amenitiesRating + bookingProcessRating + wholeExpRating + serviceRating) / 4;
		review.setOverallRating(overallRating);
    	reviewService.save(review);
        return ResponseEntity.ok("Review submitted successfully");
    }
    
	@RequestMapping(value = "findReviews/{hotelId}", method = RequestMethod.GET)
	@CrossOrigin(origins = "http://localhost:8282")
	public List<Review> findReviewsByHotelId(@PathVariable int hotelId) {
		System.out.println("reviewshotelId" + hotelId);
		System.out.println("reviews" + reviewService.findByHotelId(hotelId));
	    return reviewService.findByHotelId(hotelId);
	}
    
    @RequestMapping(value = "findAllReviews", method = RequestMethod.GET)
    public List<Review> findAll(){
    	return reviewService.findAll();
    }
    
//    @RequestMapping(value = "updateReview", method = RequestMethod.PUT)
//    public Review updateReview(@RequestBody Review review) {
//    	return reviewService.update(review);
//    }
}
