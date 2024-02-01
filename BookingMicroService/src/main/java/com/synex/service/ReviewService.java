package com.synex.service;

import java.util.List;

import org.springframework.stereotype.Service;
import com.synex.domain.Review;

@Service
public interface ReviewService {
	public Review save(Review review);
    public Review findById(Integer reviewId);
    public List<Review> findAll();
    public void deleteById(Integer reviewId);
    boolean existsById(Integer reviewId);
    public List<Review> findByHotelId(Integer hotelId);
}
