package com.love.article.auth.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.love.article.auth.domain.ApplicationUser;


public interface UserRepository extends JpaRepository<ApplicationUser, UUID>{
	
	public ApplicationUser findByUsername(String username);

}
