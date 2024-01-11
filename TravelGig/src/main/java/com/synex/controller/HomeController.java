package com.synex.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	@GetMapping("/Home")
	public String Home() {
		System.out.println("Home");
		return "Home";
	}
}
