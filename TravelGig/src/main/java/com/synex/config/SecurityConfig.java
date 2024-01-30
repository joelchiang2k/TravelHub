package com.synex.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.synex.service.UserService;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true, securedEnabled = true, jsr250Enabled = true)
public class SecurityConfig {
	@Autowired UserService userService;
 	@Autowired BCryptPasswordEncoder bCrypt;
	@Autowired UserDetailsService u;
	@Autowired AuthenticationSuccessHandler successHandler;
	@Autowired AccessDeniedHandler accessDeniedHandler;
	
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}
	
	@Bean
	DaoAuthenticationProvider authProvider() {
		DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
		authProvider.setUserDetailsService(u);
		authProvider.setPasswordEncoder(bCrypt);
		return authProvider;
	}
	

//	
//	@Bean
//	SecurityFilterChain filterChain(HttpSecurity http) throws Exception{
//		http.authorizeHttpRequests().anyRequest().permitAll();
////		http.csrf().disable()
////		.authorizeHttpRequests().requestMatchers(AntPathRequestMatcher.antMatcher("/")).permitAll()
////		.requestMatchers(AntPathRequestMatcher.antMatcher("/login")).permitAll()
////		.requestMatchers(AntPathRequestMatcher.antMatcher("/Home")).permitAll()
////		.requestMatchers(AntPathRequestMatcher.antMatcher("/userForm")).permitAll()
////		.requestMatchers(AntPathRequestMatcher.antMatcher("/roleForm")).permitAll()
////		.requestMatchers(AntPathRequestMatcher.antMatcher("/WEB-INF/views/**")).permitAll()
////		.anyRequest().authenticated() //requires authentication for any other request
////		.and()
////		.formLogin()// required to display the default form provided by Spring to login
////		.disable();
//		
//		http.userDetailsService(u);
//		http.authenticationProvider(authProvider());
//		
//		return http.build();
//	}
//	@Bean
//	public PasswordEncoder passwordEncoder() {
//		return new BCryptPasswordEncoder();
//	}
	@Bean 
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
		.apply(MyCustomDsl.customDsl()).flag(true).and()
		.authorizeRequests().requestMatchers("/", "/home").permitAll().and()
		.authorizeRequests().requestMatchers("/confirmBooking")
		.hasAnyAuthority("User","Admin").and().formLogin().loginPage("/login").defaultSuccessUrl("/home")
		.permitAll().and().logout().logoutSuccessUrl("/login?logout").invalidateHttpSession(true)
		.deleteCookies("JSESSIONID").permitAll();
		
		http.userDetailsService(u);
		http.authenticationProvider(authProvider());
		
		return http.build();
	}
}
