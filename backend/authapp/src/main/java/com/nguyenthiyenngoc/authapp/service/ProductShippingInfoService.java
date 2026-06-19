package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ProductShippingInfo;

import java.util.List;
import java.util.UUID;

public interface ProductShippingInfoService {

    List<ProductShippingInfo> getAllProductShippingInfos();

    ProductShippingInfo getProductShippingInfoById(UUID id);

    ProductShippingInfo createProductShippingInfo(ProductShippingInfo productShippingInfo);

    ProductShippingInfo updateProductShippingInfo(UUID id, ProductShippingInfo productShippingInfo);

    void deleteProductShippingInfo(UUID id);
}
