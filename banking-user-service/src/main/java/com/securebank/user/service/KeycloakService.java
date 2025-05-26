package com.securebank.user.service;

import com.securebank.user.dto.UserDto;

public interface KeycloakService {
    String createUser(UserDto userDto);
    void updateUser(String keycloakId, UserDto userDto);
    void deleteUser(String keycloakId);
    void resetPassword(String keycloakId, String newPassword);
}
