package com.synex.config;

import java.util.Properties;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

@Configuration
public class AppConfig {
	@Autowired DataSource dataSource;
	
	@Bean
	@Primary
	public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
		LocalContainerEntityManagerFactoryBean entityManager = new LocalContainerEntityManagerFactoryBean();
		entityManager.setPackagesToScan("com.synex.domain");
		entityManager.setDataSource(dataSource);
		entityManager.setJpaProperties(properties());
		entityManager.setJpaVendorAdapter(new HibernateJpaVendorAdapter());
		
		return entityManager;
	}
	
	public Properties properties() {
		Properties p = new Properties();
		p.setProperty("hibernate.hbm2ddl.auto", "update");
		p.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL8Dialect");
		return p;
	}
	
	public LocalSessionFactoryBean sessionFactory() {
		LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
		sessionFactory.setDataSource(dataSource);
		sessionFactory.setAnnotatedPackages("com.synex.domain");
		sessionFactory.setHibernateProperties(properties());
		
		return sessionFactory;
	}
	
//	@Bean
//	NoOpPasswordEncoder noOpPasswordEncoder() {
//		return (NoOpPasswordEncoder) NoOpPasswordEncoder.getInstance();
//	}
	
	@Bean
	BCryptPasswordEncoder bCryptPasswordEncoder() {
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		String encrypted = encoder.encode("joel");
		System.out.println("encrypted:" + encrypted);
		return encoder;
	}
//	
	@Bean
	public ViewResolver viewResolver() {
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		 viewResolver.setPrefix("WEB-INF/views/");
		 viewResolver.setSuffix(".jsp");
		return  viewResolver;
	}
}