package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Supplier;
import com.nguyenthiyenngoc.authapp.repository.SupplierRepository;
import com.nguyenthiyenngoc.authapp.service.SupplierService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class SupplierServiceImpl implements SupplierService {

    private final SupplierRepository supplierRepository;

    public SupplierServiceImpl(SupplierRepository supplierRepository) {
        this.supplierRepository = supplierRepository;
    }

    @Override
    public List<Supplier> getAllSuppliers() {
        return supplierRepository.findAll();
    }

    @Override
    public Supplier getSupplierById(UUID id) {
        return supplierRepository.findById(id).orElse(null);
    }

    @Override
    public Supplier createSupplier(Supplier supplier) {
        return supplierRepository.save(supplier);
    }

    @Override
    public Supplier updateSupplier(UUID id, Supplier supplier) {

        Supplier existing =
                supplierRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setSupplierName(supplier.getSupplierName());
        existing.setCompany(supplier.getCompany());
        existing.setPhoneNumber(supplier.getPhoneNumber());
        existing.setAddressLine1(supplier.getAddressLine1());
        existing.setAddressLine2(supplier.getAddressLine2());
        existing.setCountry(supplier.getCountry());
        existing.setCity(supplier.getCity());
        existing.setNote(supplier.getNote());
        existing.setCreatedBy(supplier.getCreatedBy());
        existing.setUpdatedBy(supplier.getUpdatedBy());

        return supplierRepository.save(existing);
    }

    @Override
    public void deleteSupplier(UUID id) {
        supplierRepository.deleteById(id);
    }
}
