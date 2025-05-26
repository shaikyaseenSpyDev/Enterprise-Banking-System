package com.securebank.user.service.impl;

import com.securebank.user.dto.UserDto;
import com.securebank.user.service.KeycloakService;
import lombok.RequiredArgsConstructor;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.admin.client.resource.UsersResource;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.ws.rs.core.Response;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class KeycloakServiceImpl implements KeycloakService {

    private final Keycloak keycloak;

    @Value("${keycloak.realm}")
    private String realm;

    @Override
    public String createUser(UserDto userDto) {
        UserRepresentation user = new UserRepresentation();
        user.setEnabled(true);
        user.setUsername(userDto.getUsername());
        user.setFirstName(userDto.getFirstName());
        user.setLastName(userDto.getLastName());
        user.setEmail(userDto.getEmail());
        
        // Set required actions
        user.setRequiredActions(Collections.singletonList("UPDATE_PASSWORD"));
        
        // Set additional attributes
        Map<String, List<String>> attributes = new HashMap<>();
        if (userDto.getPhoneNumber() != null) {
            attributes.put("phoneNumber", Collections.singletonList(userDto.getPhoneNumber()));
        }
        if (userDto.getAddress() != null) {
            attributes.put("address", Collections.singletonList(userDto.getAddress()));
        }
        user.setAttributes(attributes);
        
        // Create user
        Response response = getRealmResource().users().create(user);
        
        if (response.getStatus() == 201) {
            String userId = getCreatedUserId(response);
            
            // Set password
            if (userDto.getPassword() != null && !userDto.getPassword().isEmpty()) {
                CredentialRepresentation credential = new CredentialRepresentation();
                credential.setType(CredentialRepresentation.PASSWORD);
                credential.setValue(userDto.getPassword());
                credential.setTemporary(true);
                
                getUserResource(userId).resetPassword(credential);
            }
            
            return userId;
        }
        
        throw new RuntimeException("Failed to create user in Keycloak: " + response.getStatusInfo().getReasonPhrase());
    }

    @Override
    public void updateUser(String keycloakId, UserDto userDto) {
        UserResource userResource = getUserResource(keycloakId);
        UserRepresentation user = userResource.toRepresentation();
        
        if (userDto.getUsername() != null) {
            user.setUsername(userDto.getUsername());
        }
        if (userDto.getEmail() != null) {
            user.setEmail(userDto.getEmail());
        }
        if (userDto.getFirstName() != null) {
            user.setFirstName(userDto.getFirstName());
        }
        if (userDto.getLastName() != null) {
            user.setLastName(userDto.getLastName());
        }
        
        // Update attributes
        Map<String, List<String>> attributes = user.getAttributes();
        if (attributes == null) {
            attributes = new HashMap<>();
        }
        
        if (userDto.getPhoneNumber() != null) {
            attributes.put("phoneNumber", Collections.singletonList(userDto.getPhoneNumber()));
        }
        if (userDto.getAddress() != null) {
            attributes.put("address", Collections.singletonList(userDto.getAddress()));
        }
        
        user.setAttributes(attributes);
        user.setEnabled(userDto.isEnabled());
        
        userResource.update(user);
        
        // Update password if provided
        if (userDto.getPassword() != null && !userDto.getPassword().isEmpty()) {
            resetPassword(keycloakId, userDto.getPassword());
        }
    }

    @Override
    public void deleteUser(String keycloakId) {
        getUserResource(keycloakId).remove();
    }

    @Override
    public void resetPassword(String keycloakId, String newPassword) {
        CredentialRepresentation credential = new CredentialRepresentation();
        credential.setType(CredentialRepresentation.PASSWORD);
        credential.setValue(newPassword);
        credential.setTemporary(false);
        
        getUserResource(keycloakId).resetPassword(credential);
    }
    
    private RealmResource getRealmResource() {
        return keycloak.realm(realm);
    }
    
    private UsersResource getUsersResource() {
        return getRealmResource().users();
    }
    
    private UserResource getUserResource(String userId) {
        return getUsersResource().get(userId);
    }
    
    private String getCreatedUserId(Response response) {
        String locationHeader = response.getHeaderString("Location");
        if (locationHeader != null) {
            String[] parts = locationHeader.split("/");
            return parts[parts.length - 1];
        }
        throw new RuntimeException("Could not extract user ID from response");
    }
}
