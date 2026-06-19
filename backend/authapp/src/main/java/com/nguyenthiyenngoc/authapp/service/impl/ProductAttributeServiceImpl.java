package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ProductAttribute;
import com.nguyenthiyenngoc.authapp.repository.ProductAttributeRepository;
import com.nguyenthiyenngoc.authapp.service.ProductAttributeService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ProductAttributeServiceImpl implements ProductAttributeService {

    private final ProductAttributeRepository productAttributeRepository;

    public ProductAttributeServiceImpl(ProductAttributeRepository productAttributeRepository) {
        this.productAttributeRepository = productAttributeRepository;
    }

    @Override
    public List<ProductAttribute> getAllProductAttributes() {
        return productAttributeRepository.findAll();
    }

    @Override
    public ProductAttribute getProductAttributeById(UUID id) {
        return productAttributeRepository.findById(id).orElse(null);
    }

    @Override
    public ProductAttribute createProductAttribute(ProductAttribute productAttribute) {
        return productAttributeRepository.save(productAttribute);
    }

    @Override
    public ProductAttribute updateProductAttribute(UUID id, ProductAttribute productAttribute) {
        ProductAttribute existing = productAttributeRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setProduct(productAttribute.getProduct());
        existing.setAttribute(productAttribute.getAttribute());
        return productAttributeRepository.save(existing);
    }

    @Override
    public void deleteProductAttribute(UUID id) {
        productAttributeRepository.deleteById(id);
    }
}
