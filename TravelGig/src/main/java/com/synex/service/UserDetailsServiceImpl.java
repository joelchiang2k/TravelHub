package com.synex.service;


import java.util.Collection;
import java.util.HashSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.synex.domain.Role;
import com.synex.domain.User;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
	
	@Autowired UserService userService;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// TODO Auto-generated method stub
		System.out.println("username: " + username);
		User user = userService.findUserByUsername(username);
		user.getRoles();
		Collection<GrantedAuthority> authorities = new HashSet<>();
		if(user != null) {
			System.out.println("user from DB: " + username);
		
			
			for(Role role : user.getRoles()) {
				System.out.println(role.getName());
				authorities.add(new SimpleGrantedAuthority(role.getName()));
			}
		}
		
		return new org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), authorities);
	}

}
