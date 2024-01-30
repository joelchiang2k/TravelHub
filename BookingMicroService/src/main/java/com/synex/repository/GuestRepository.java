package com.synex.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.synex.domain.Guest;

public interface GuestRepository extends JpaRepository<Guest, Integer> {

}
