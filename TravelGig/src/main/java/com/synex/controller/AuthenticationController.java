package com.synex.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.synex.service.UserService;

@Controller
public class AuthenticationController {
	@Autowired UserService userService;
	
	@GetMapping("/checkAuthentication")
	@ResponseBody
	public Map<String, Boolean> checkAuthentication(){
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		boolean isAuthenticated = authentication != null && !(authentication instanceof AnonymousAuthenticationToken);
		
		Map<String, Boolean> response = new HashMap<>();
		response.put("authenticated", isAuthenticated);
		
		return response;
	}
}
