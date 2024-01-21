package com.synex.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.synex.domain.User;

@Service
public interface UserService {
	public User save(User user);
	public User findById(Long userId);
	public List<User> findAll();
	public void deleteById(Long userId);
	
	public User updateById(Long userId);
	
	User findUserByUsername(String username);
	
	public boolean existsById(Long userId);
	
}
