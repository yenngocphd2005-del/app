package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ProductSupplier;
import com.nguyenthiyenngoc.authapp.service.ProductSupplierService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/product-suppliers")
@CrossOrigin(origins = "*")
public class ProductSupplierController {

    private final ProductSupplierService productSupplierService;

    public ProductSupplierController(ProductSupplierService productSupplierService) {
        this.productSupplierService = productSupplierService;
    }

    @GetMapping
    public List<ProductSupplier> getAllProductSuppliers() {
        return productSupplierService.getAllProductSuppliers();
    }

    @GetMapping("/{id}")
    public ProductSupplier getProductSupplierById(@PathVariable UUID id) {
        return productSupplierService.getProductSupplierById(id);
    }

    @PostMapping
    public ProductSupplier createProductSupplier(@RequestBody ProductSupplier productSupplier) {
        return productSupplierService.createProductSupplier(productSupplier);
    }

    @PutMapping("/{id}")
    public ProductSupplier updateProductSupplier(
            @PathVariable UUID id,
            @RequestBody ProductSupplier productSupplier) {
        return productSupplierService.updateProductSupplier(id, productSupplier);
    }

    @DeleteMapping("/{id}")
    public void deleteProductSupplier(@PathVariable UUID id) {
        productSupplierService.deleteProductSupplier(id);
    }
}
