package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Supplier;

import java.util.List;
import java.util.UUID;

public interface SupplierService {

    List<Supplier> getAllSuppliers();

    Supplier getSupplierById(UUID id);

    Supplier createSupplier(Supplier supplier);

    Supplier updateSupplier(UUID id, Supplier supplier);

    void deleteSupplier(UUID id);
}
