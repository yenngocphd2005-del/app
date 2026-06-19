package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ProductCoupon;

import java.util.List;
import java.util.UUID;

public interface ProductCouponService {

    List<ProductCoupon> getAllProductCoupons();

    ProductCoupon getProductCouponById(UUID id);

    ProductCoupon createProductCoupon(ProductCoupon productCoupon);

    ProductCoupon updateProductCoupon(UUID id, ProductCoupon productCoupon);

    void deleteProductCoupon(UUID id);
}
