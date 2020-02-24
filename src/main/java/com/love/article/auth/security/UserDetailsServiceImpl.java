package com.love.article.auth.security;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.love.article.auth.domain.ApplicationUser;
import com.love.article.auth.repository.UserRepository;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

	@Autowired
	private UserRepository userRepository;

	@Autowired
	private BCryptPasswordEncoder encoder;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

		ApplicationUser user = userRepository.findByUsername(username);

		if (user != null) {

			// Remember that Spring needs roles to be in this format: "ROLE_" + userRole
			// (i.e. "ROLE_ADMIN")
			// So, we need to set it to that format, so we can verify and compare roles
			// (i.e. hasRole("ADMIN")).
			List<GrantedAuthority> grantedAuthorities = AuthorityUtils.commaSeparatedStringToAuthorityList(
					user.getRoles().stream().map(role -> "ROLE_" + role.getName()).collect(Collectors.toList()).stream()
							.map(String::toUpperCase).collect(Collectors.joining(",")));

			// The "User" class is provided by Spring and represents a model class for user
			// to be returned by UserDetailsService
			// And used by auth manager to verify and check user authentication.
			return new User(user.getUsername(), user.getPassword(), grantedAuthorities);
		}

		// If user not found. Throw this exception.
		throw new UsernameNotFoundException("Username: " + username + " not found");
	}

}