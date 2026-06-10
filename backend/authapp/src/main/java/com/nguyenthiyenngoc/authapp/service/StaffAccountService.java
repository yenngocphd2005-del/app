package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.StaffAccount;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

public interface StaffAccountService {
    AuthResponse register(SignUpRequest request);
    AuthResponse login(AuthRequest request);
    AuthResponse socialLogin(SocialLoginRequest request);
    StaffAccount getAccountById(UUID id);

    @Data
    class AuthRequest {
        private String email;
        private String password;
    }

    @Data
    @Builder
    class AuthResponse {
        private boolean success;
        private String message;
        private String token;
        private UserDto user;

        @Data
        @Builder
        public static class UserDto {
            private UUID id;
            private String firstName;
            private String lastName;
            private String email;
            private String phoneNumber;
            private String roleName;
        }
    }

    @Data
    class SignUpRequest {
        private String firstName;
        private String lastName;
        private String phoneNumber;
        private String email;
        private String password;
        private String image;
        private String placeholder;
    }

    @Data
    class SocialLoginRequest {
        private String provider;
        private String token;
        private boolean signUp;
    }
}
