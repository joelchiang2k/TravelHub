package com.synex.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.synex.domain.Role;

@Service
public interface RoleService {
      public Role save(Role role);
      public Role findById(Long roleId);
      public List<Role> findAll();
      public void deleteById(Long roleId);
      public boolean existsById(Long roleId);
}
