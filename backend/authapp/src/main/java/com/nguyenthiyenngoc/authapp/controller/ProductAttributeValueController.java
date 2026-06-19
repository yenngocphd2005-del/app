package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ProductAttributeValue;
import com.nguyenthiyenngoc.authapp.service.ProductAttributeValueService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/product-attribute-values")
@CrossOrigin(origins = "*")
public class ProductAttributeValueController {

    private final ProductAttributeValueService productAttributeValueService;

    public ProductAttributeValueController(ProductAttributeValueService productAttributeValueService) {
        this.productAttributeValueService = productAttributeValueService;
    }

    @GetMapping
    public List<ProductAttributeValue> getAllProductAttributeValues() {
        return productAttributeValueService.getAllProductAttributeValues();
    }

    @GetMapping("/{id}")
    public ProductAttributeValue getProductAttributeValueById(@PathVariable UUID id) {
        return productAttributeValueService.getProductAttributeValueById(id);
    }

    @PostMapping
    public ProductAttributeValue createProductAttributeValue(@RequestBody ProductAttributeValue productAttributeValue) {
        return productAttributeValueService.createProductAttributeValue(productAttributeValue);
    }

    @PutMapping("/{id}")
    public ProductAttributeValue updateProductAttributeValue(
            @PathVariable UUID id,
            @RequestBody ProductAttributeValue productAttributeValue) {
        return productAttributeValueService.updateProductAttributeValue(id, productAttributeValue);
    }

    @DeleteMapping("/{id}")
    public void deleteProductAttributeValue(@PathVariable UUID id) {
        productAttributeValueService.deleteProductAttributeValue(id);
    }
}
