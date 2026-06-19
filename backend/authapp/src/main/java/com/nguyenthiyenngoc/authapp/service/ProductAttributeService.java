package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ProductAttribute;

import java.util.List;
import java.util.UUID;

public interface ProductAttributeService {

    List<ProductAttribute> getAllProductAttributes();

    ProductAttribute getProductAttributeById(UUID id);

    ProductAttribute createProductAttribute(ProductAttribute productAttribute);

    ProductAttribute updateProductAttribute(UUID id, ProductAttribute productAttribute);

    void deleteProductAttribute(UUID id);
}
