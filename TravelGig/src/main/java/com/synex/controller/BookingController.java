package com.synex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BookingController {
	@GetMapping({"/booking"})
	public String Home() {
		return "booking";
	}
}
