package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ProductAttributeValue;

import java.util.List;
import java.util.UUID;

public interface ProductAttributeValueService {

    List<ProductAttributeValue> getAllProductAttributeValues();

    ProductAttributeValue getProductAttributeValueById(UUID id);

    ProductAttributeValue createProductAttributeValue(ProductAttributeValue productAttributeValue);

    ProductAttributeValue updateProductAttributeValue(UUID id, ProductAttributeValue productAttributeValue);

    void deleteProductAttributeValue(UUID id);
}
