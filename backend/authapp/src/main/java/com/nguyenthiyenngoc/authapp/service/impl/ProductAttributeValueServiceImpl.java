package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ProductAttributeValue;
import com.nguyenthiyenngoc.authapp.repository.ProductAttributeValueRepository;
import com.nguyenthiyenngoc.authapp.service.ProductAttributeValueService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ProductAttributeValueServiceImpl implements ProductAttributeValueService {

    private final ProductAttributeValueRepository productAttributeValueRepository;

    public ProductAttributeValueServiceImpl(ProductAttributeValueRepository productAttributeValueRepository) {
        this.productAttributeValueRepository = productAttributeValueRepository;
    }

    @Override
    public List<ProductAttributeValue> getAllProductAttributeValues() {
        return productAttributeValueRepository.findAll();
    }

    @Override
    public ProductAttributeValue getProductAttributeValueById(UUID id) {
        return productAttributeValueRepository.findById(id).orElse(null);
    }

    @Override
    public ProductAttributeValue createProductAttributeValue(ProductAttributeValue productAttributeValue) {
        return productAttributeValueRepository.save(productAttributeValue);
    }

    @Override
    public ProductAttributeValue updateProductAttributeValue(UUID id, ProductAttributeValue productAttributeValue) {
        ProductAttributeValue existing = productAttributeValueRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setProductAttribute(productAttributeValue.getProductAttribute());
        existing.setAttributeValue(productAttributeValue.getAttributeValue());
        return productAttributeValueRepository.save(existing);
    }

    @Override
    public void deleteProductAttributeValue(UUID id) {
        productAttributeValueRepository.deleteById(id);
    }
}
