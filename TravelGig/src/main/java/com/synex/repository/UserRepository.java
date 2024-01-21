package com.synex.repository;

import com.synex.domain.User;

import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepository extends JpaRepository<User, Long> {
	User findUserByUsername(String username);
}
