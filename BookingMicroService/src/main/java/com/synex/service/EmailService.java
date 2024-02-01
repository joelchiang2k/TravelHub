package com.synex.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.synex.domain.Booking;
import com.synex.domain.Guest;

import jakarta.mail.Multipart;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;

@Service
@EnableAutoConfiguration
public class EmailService {
	@Autowired private JavaMailSender javaMailSender;
	@Autowired private InvoiceService invoiceService;
	
	@Async
	public void sendBookingConfirmation(Booking booking) {
		System.out.println("booking.getUser" + booking.getUserEmail());
		try {
			MimeMessage message = javaMailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message);
			
			byte[] invoiceBytes = invoiceService.generateInvoice(booking);
			MimeBodyPart attachmentPart = new MimeBodyPart();
			attachmentPart.setContent(invoiceBytes, "application/pdf");
			attachmentPart.setFileName("invoice.pdf");
			
			MimeBodyPart textPart = new MimeBodyPart();
			textPart.setContent(this.getEmailBody(booking), "text/html;charset=UTF-8");
			
			
			helper.setTo("joelsession3@gmail.com");
			helper.setSubject("Time to Unwind: Your Hotel Stay is Official!");
			
			Multipart multipart = new MimeMultipart();
			multipart.addBodyPart(attachmentPart);
			multipart.addBodyPart(textPart);
			
			message.setContent(multipart);
			javaMailSender.send(message);
		} catch (Exception e) {
			System.err.println("Email Sending Exception: " + e.getMessage());
		}
	}
	
	public String getEmailBody(Booking booking) {
		StringBuilder guestTable = new StringBuilder();
		
		for(Guest guest : booking.getGuests()) {
			String guestRow = """
					<tr>
						<td>%s</td>
						<td>%s</td>
						<td>%s</td>
						<td>%d</td>
						</td>
					</tr>
					""".formatted(
							guest.getFirstName(),
							guest.getLastName(),
							guest.getGender(),
							guest.getAge()	
					);
					
					guestTable.append(guestRow);
		}	
			String htmlTemplate = """
					<!DOCTYPE html>
					<html>
					<head>
						<title>Hotel Confirmation</title>
					</head>
					<body>
					
					<div class="container">
						<h1>Your Stay at %s is Confirmed!</h1>
						<p>Check-in Date: %s</p>
						<p>Check-out Date: %s</p>
				
						<p>Status: %s</p>
						
						<p>Guests Information</p>
						<table>
							<thead>
								<tr>
									<th>Guest Details</th>
								</tr>
								<tr>
									<th>First Name</th>
									<th>Last Name</th>
									<th>Gender</th>
									<th>Age</th>
								</tr>
							  </thead>
							  <tbody>
							  	%s <!== Insert guest rows here -->
							  </tbody>
						</table>
						<hr/>
						<table>
							<tr>
								<th>Booking Details</th>
							</tr>
							<tr>
								<td>
									<p>Room Type: %s</p>
									<p>No. of Rooms: %d</p>
									<p>Price per Room: $%.2f</p>
									<p>Discount: %.2f%%</p>
									<p>Tax Rate: %.2f%%</p>
									<p>Final Charges: $%.2f</p>
									<p>Bonanza Discount: $%.2f</p>
									<p>Total Savings: $%.2f</p>
								</td>
							</tr>
						 </table>
					  </div>
					</body>
					</html>
					""".formatted(
							booking.getHotelName(),
							booking.getCheckInDate(),
							booking.getCheckOutDate(),
							booking.getStatus(),
							guestTable.toString(),
							booking.getRoomType(),
							booking.getNoRooms(),
							booking.getPrice(),
							booking.getDiscount(),
							booking.getTaxRateInPercent(),
							booking.getFinalCharges(),
							booking.getBonanzaDiscount(),
							booking.getTotalSavings()
					
							);
			
			return htmlTemplate;
		}
	}

