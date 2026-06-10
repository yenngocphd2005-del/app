package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Role;
import java.util.List;
import java.util.UUID;

public interface RoleService {
    Role createRole(Role role);
    Role getRoleById(UUID id);
    Role getRoleByName(String roleName);
    List<Role> getAllRoles();
    void deleteRole(UUID id);
}
