package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ProductAttribute;
import com.nguyenthiyenngoc.authapp.service.ProductAttributeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/product-attributes")
@CrossOrigin(origins = "*")
public class ProductAttributeController {

    private final ProductAttributeService productAttributeService;

    public ProductAttributeController(ProductAttributeService productAttributeService) {
        this.productAttributeService = productAttributeService;
    }

    @GetMapping
    public List<ProductAttribute> getAllProductAttributes() {
        return productAttributeService.getAllProductAttributes();
    }

    @GetMapping("/{id}")
    public ProductAttribute getProductAttributeById(@PathVariable UUID id) {
        return productAttributeService.getProductAttributeById(id);
    }

    @PostMapping
    public ProductAttribute createProductAttribute(@RequestBody ProductAttribute productAttribute) {
        return productAttributeService.createProductAttribute(productAttribute);
    }

    @PutMapping("/{id}")
    public ProductAttribute updateProductAttribute(
            @PathVariable UUID id,
            @RequestBody ProductAttribute productAttribute) {
        return productAttributeService.updateProductAttribute(id, productAttribute);
    }

    @DeleteMapping("/{id}")
    public void deleteProductAttribute(@PathVariable UUID id) {
        productAttributeService.deleteProductAttribute(id);
    }
}
