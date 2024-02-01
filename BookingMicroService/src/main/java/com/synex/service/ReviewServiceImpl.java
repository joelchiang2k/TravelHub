package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.synex.domain.Review;
import com.synex.repository.ReviewRepository;

@Service
public class ReviewServiceImpl implements ReviewService {
	@Autowired ReviewRepository reviewRepository;
	
	@Override
	public Review save(Review review) {
		// TODO Auto-generated method stub
		return reviewRepository.save(review);
	}

	@Override
	public Review findById(Integer reviewId) {
		Optional<Review> optReview = reviewRepository.findById(reviewId);
		if(optReview.isPresent()) {
			return optReview.get();
		}
		return null;
	}

	@Override
	public List<Review> findAll() {
		// TODO Auto-generated method stub
		return reviewRepository.findAll();
	}

	@Override
	public void deleteById(Integer reviewId) {
		// TODO Auto-generated method stub
		reviewRepository.deleteById(reviewId);
	}

	@Override
	public boolean existsById(Integer reviewId) {
		// TODO Auto-generated method stub
		return reviewRepository.existsById(reviewId);
	}
	
	public List<Review> findByHotelId(Integer hotelId) {
        return reviewRepository.findByHotelId(hotelId);
    }

}
