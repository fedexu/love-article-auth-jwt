package com.love.article.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class AuthJwtApplication {

	public static void main(String[] args) {
		SpringApplication.run(AuthJwtApplication.class, args);
	}
}
