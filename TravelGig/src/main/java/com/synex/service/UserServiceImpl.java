package com.synex.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.synex.repository.UserRepository;
import com.synex.domain.User;

@Service
public class UserServiceImpl implements UserService {

	@Autowired UserRepository userRepository;
	@Autowired BCryptPasswordEncoder encoder;
	
	@Override
	public User save(User user) {
		String encryptedPassword = encoder.encode(user.getPassword());
		user.setPassword(encryptedPassword);
		return userRepository.save(user);
	}

	@Override
	public User findById(Long userId) {
		Optional<User> optUser = userRepository.findById(userId);
		if(optUser.isPresent()) {
			return optUser.get();
		}
		return null;
	}

	@Override
	public List<User> findAll() {
		return userRepository.findAll();
	}

	@Override
	public void deleteById(Long userId) {
		userRepository.deleteById(userId);
	}

	@Override
	public User updateById(Long userId) { // This method used is used only to fill the form, it can also be managed by method findById(Long userId). 
		Optional<User> optUser = userRepository.findById(userId);
		if(optUser.isPresent())
			return optUser.get();
		return null;
	}
	
	@Override
	public User findUserByUsername(String username) {
		return userRepository.findUserByUsername(username);
	}
	
	@Override
	public boolean existsById(Long userId) {
		return userRepository.existsById(userId);
	}
}
