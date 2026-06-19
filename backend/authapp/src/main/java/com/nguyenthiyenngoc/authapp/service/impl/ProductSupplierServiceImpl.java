package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ProductSupplier;
import com.nguyenthiyenngoc.authapp.repository.ProductSupplierRepository;
import com.nguyenthiyenngoc.authapp.service.ProductSupplierService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ProductSupplierServiceImpl implements ProductSupplierService {

    private final ProductSupplierRepository productSupplierRepository;

    public ProductSupplierServiceImpl(ProductSupplierRepository productSupplierRepository) {
        this.productSupplierRepository = productSupplierRepository;
    }

    @Override
    public List<ProductSupplier> getAllProductSuppliers() {
        return productSupplierRepository.findAll();
    }

    @Override
    public ProductSupplier getProductSupplierById(UUID id) {
        return productSupplierRepository.findById(id).orElse(null);
    }

    @Override
    public ProductSupplier createProductSupplier(ProductSupplier productSupplier) {
        return productSupplierRepository.save(productSupplier);
    }

    @Override
    public ProductSupplier updateProductSupplier(UUID id, ProductSupplier productSupplier) {
        ProductSupplier existing = productSupplierRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setProduct(productSupplier.getProduct());
        existing.setSupplier(productSupplier.getSupplier());
        return productSupplierRepository.save(existing);
    }

    @Override
    public void deleteProductSupplier(UUID id) {
        productSupplierRepository.deleteById(id);
    }
}
