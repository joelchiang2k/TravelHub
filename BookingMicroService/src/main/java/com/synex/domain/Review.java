package com.synex.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;


@Entity
@Table(name="review")
public class Review {
		
		@Id
		@GeneratedValue(strategy=GenerationType.IDENTITY)
		private int reviewId;
		
		@OneToOne
		private Booking booking;
		private String text;
		private int serviceRating;
		private int amenitiesRating;
		private int bookingProcessRating;
		private int wholeExpRating;
		private double overallRating;
		
		@Transient
		private boolean exists;
		
		public int getReviewId() {
			return reviewId;
		}
		public void setReviewId(int reviewId) {
			this.reviewId = reviewId;
		}
		public Booking getBooking() {
			return booking;
		}
		public void setBooking(Booking booking) {
			this.booking = booking;
		}
		public String getText() {
			return text;
		}
		public void setText(String text) {
			this.text = text;
		}
		public int getServiceRating() {
			return serviceRating;
		}
		public void setServiceRating(int serviceRating) {
			this.serviceRating = serviceRating;
		}
		public int getAmenitiesRating() {
			return amenitiesRating;
		}
		public void setAmenitiesRating(int amenitiesRating) {
			this.amenitiesRating = amenitiesRating;
		}
		public int getBookingProcessRating() {
			return bookingProcessRating;
		}
		public void setBookingProcessRating(int bookingProcessRating) {
			this.bookingProcessRating = bookingProcessRating;
		}
		public int getWholeExpRating() {
			return wholeExpRating;
		}
		public void setWholeExpRating(int wholeExpRating) {
			this.wholeExpRating = wholeExpRating;
		}
		public double getOverallRating() {
			return overallRating;
		}
		public void setOverallRating(double overallRating) {
			this.overallRating = overallRating;
		}
		public boolean isExists() {
			return exists;
		}
		public void setExists(boolean exists) {
			this.exists = exists;
		}
			
}
