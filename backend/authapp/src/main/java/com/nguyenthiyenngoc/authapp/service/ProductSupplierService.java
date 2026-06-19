package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ProductSupplier;

import java.util.List;
import java.util.UUID;

public interface ProductSupplierService {

    List<ProductSupplier> getAllProductSuppliers();

    ProductSupplier getProductSupplierById(UUID id);

    ProductSupplier createProductSupplier(ProductSupplier productSupplier);

    ProductSupplier updateProductSupplier(UUID id, ProductSupplier productSupplier);

    void deleteProductSupplier(UUID id);
}
