package com.synex.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.synex.domain.Booking;
import com.synex.service.BookingService;
import com.synex.service.EmailService;

@RestController
public class BookingController {
	@Autowired BookingService bookingService;
	@Autowired EmailService emailService;
	@Autowired ObjectMapper objectMapper;
	//@Autowired HotelService hotelService;
	@Autowired RestTemplate restTemplate;
	
	@PostMapping("/bookHotel")
	@CrossOrigin(origins = "http://localhost:8282")
	public ResponseEntity<String> createBooking(@RequestBody Booking booking){
		System.out.println("status" + booking.getStatus());
		try {
			Booking savedBooking = booking;
			System.out.println("savedBooking" + savedBooking);
			JsonNode hotel = restTemplate.getForObject("http://localhost:8383/hotel/{hotelId}", JsonNode.class, savedBooking.getHotelId());
			//JsonNode hotel = hotelService.findHotelById(savedBooking.getHotelId());
			System.out.println("hotel" + hotel);
			if(hotel != null) {
				savedBooking.setHotelName(hotel.path("hotelName").asText());
				
				CompletableFuture.runAsync(() -> {
					try {
						emailService.sendBookingConfirmation(savedBooking);
					} catch (Exception e) {
						e.printStackTrace();
					}
				});
				
				String savedBookingJson = objectMapper.writeValueAsString(savedBooking);
				return ResponseEntity.status(HttpStatus.CREATED).body(savedBookingJson);
			} else {
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("No available rooms for the specified criteria.");
			}
		} catch (IOException e) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Invalid JSON data: " + e.getMessage());
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error creating booking: " + e.getMessage());
		}
	}
	
//	private boolean areRoomsAvailable(JsonNode hotel, Booking booking) {
//		JsonNode hotelRooms = hotel.path("hotelRooms");
//		for(JsonNode roomNode : hotelRooms) {
//			int hotelRoomId = roomNode.path("hotelRoomId").asInt();
//			int noOfRoomsAvailable = roomNode.path("noRooms").asInt();
//			
//			if(hotelRoomId == booking.getHotelRoomId()) {
//				return noOfRoomsAvailable >= booking.getNoRooms();
//			}
//		}
//		return false;
//	}
	
	@RequestMapping(value="saveBooking", method=RequestMethod.POST)
	@CrossOrigin(origins = "http://localhost:8282")
	public Booking saveBooking(@RequestBody Booking booking)
	{
		 DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

		    LocalDate currentDate = LocalDate.now();
		    LocalDate checkInDate = LocalDate.parse(booking.getCheckInDate(), formatter);
		    LocalDate checkOutDate = LocalDate.parse(booking.getCheckOutDate(), formatter);

		    booking.setHotelId(booking.getHotelId());
		    booking.setUserEmail(booking.getUserEmail());
		    booking.setBookingId(bookingService.getNextUserId() + 1);
		    booking.setBonanzaDiscount(0);
		    booking.setTotalSavings(booking.getDiscount() + booking.getBonanzaDiscount());
		    booking.setTaxRateInPercent(3.0f);

		    float discountedPrice = booking.getPrice() * (1 - booking.getDiscount() / 100);
		    float taxAmount = discountedPrice * (booking.getTaxRateInPercent() / 100);
		    booking.setFinalCharges(discountedPrice + taxAmount);

		    booking.setBookedOnDate(currentDate.format(formatter));
		    booking.setCheckInDate(checkInDate.format(formatter));
		    booking.setCheckOutDate(checkOutDate.format(formatter));

		    // Set the status based on the current date and booking dates
		    if (currentDate.isBefore(checkInDate)) {
		        booking.setStatus("Upcoming");
		    } else if (currentDate.isEqual(checkInDate) || (currentDate.isAfter(checkInDate) && currentDate.isBefore(checkOutDate))) {
		        booking.setStatus("Current");
		    } else {
		        // Handle other cases if needed
		        booking.setStatus("Completed");
		    }
//		    System.out.println("status" + booking.getStatus());
		    
		    

		    return bookingService.save(booking);
	}
	
	@RequestMapping(value = "findAllBookings", method = RequestMethod.GET)
	@CrossOrigin(origins = "http://localhost:8282")
	public List<Booking> findAllBooking()
	{
		return bookingService.findAll();
	}
	
	@PutMapping("/cancelBooking/{bookingId}")
	@CrossOrigin(origins = "http://localhost:8282")
    public ResponseEntity<String> cancelBooking(@PathVariable Integer bookingId) {
    
        Booking booking = bookingService.findById(bookingId);
        
        if (booking == null) {
         
            return ResponseEntity.status(404).body("Booking not found");
        }

        
        booking.setStatus("CANCELLED");

      
        bookingService.save(booking);

      
        return ResponseEntity.ok("Booking canceled successfully");
    }
	
	public int roomId(Booking booking)
	{
		int roomId=0;
		if(booking.getRoomType().equals("Deluxe"))
			roomId=1;
		else if(booking.getRoomType().equals("Executive"))
			roomId=2;
		else if(booking.getRoomType().equals("Suite"))
			roomId=3;
		else if(booking.getRoomType().equals("Superior"))
			roomId=4;
		
		return roomId;
	}
	
	public int hotelId(Booking booking)
	{
		int hotelId=0;
		if(booking.getHotelName().equals("Radisson"))
			hotelId=1;
		else if(booking.getHotelName().equals("Sherraton"))
			hotelId=2;
		else if(booking.getHotelName().equals("LeMeridian"))
			hotelId=3;
		return hotelId;
	}
}
