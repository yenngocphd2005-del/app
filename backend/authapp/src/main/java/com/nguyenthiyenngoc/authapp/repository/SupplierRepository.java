package com.nguyenthiyenngoc.authapp.repository;

import com.nguyenthiyenngoc.authapp.entity.Supplier;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface SupplierRepository extends JpaRepository<Supplier, UUID> {
}
