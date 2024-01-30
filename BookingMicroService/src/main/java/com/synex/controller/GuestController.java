package com.synex.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.synex.domain.Booking;
import com.synex.domain.Guest;
import com.synex.repository.GuestRepository;
import com.synex.service.BookingService;
import com.synex.service.GuestService;

@Controller
public class GuestController {
	@Autowired 
    GuestService guestService;
	@Autowired
	BookingService bookingService;

    @RequestMapping(value = "saveGuest", method = RequestMethod.POST)
    @CrossOrigin(origins = "http://localhost:8282")
    public ResponseEntity<String> saveGuest(@RequestBody List<Guest> guests) {
//        System.out.println("guestname: " + guest.getFirstName());
//        System.out.println("guestBOokingId" + guest.getBookingId());
//        Booking booking = bookingService.findById(guest.getBookingId());
//        
//        System.out.println("booking" + booking);
//        booking.setCustomerName(guest.getFirstName());
    	System.out.println("guests" + guests);
    	for (Guest guest : guests) {
            guestService.save(guest);
        }
  
        return new ResponseEntity<>("Guest saved successfully", HttpStatus.OK);
    }
   
    @RequestMapping(value = "editGuest", method = RequestMethod.POST)
    @CrossOrigin(origins = "http://localhost:8282")
    public ResponseEntity<String> editGuest(@RequestBody List<Guest> guests) {
    	
    	System.out.println("editedguests" + guests);
        for (Guest guest : guests) {
            // Assuming that each guest has a bookingId property
            Booking booking = bookingService.findById(guest.getBookingId());
         
            System.out.println("booking: " + booking);
            
            // Assuming that you want to set the customer name for each guest
            booking.setCustomerName(guest.getFirstName());
            
            // Save the updated guest
            guestService.save(guest);
        }

        return new ResponseEntity<>("Guests saved successfully", HttpStatus.OK);
    }
}
