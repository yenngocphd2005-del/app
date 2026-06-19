package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ProductCoupon;
import com.nguyenthiyenngoc.authapp.repository.ProductCouponRepository;
import com.nguyenthiyenngoc.authapp.service.ProductCouponService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ProductCouponServiceImpl implements ProductCouponService {

    private final ProductCouponRepository productCouponRepository;

    public ProductCouponServiceImpl(ProductCouponRepository productCouponRepository) {
        this.productCouponRepository = productCouponRepository;
    }

    @Override
    public List<ProductCoupon> getAllProductCoupons() {
        return productCouponRepository.findAll();
    }

    @Override
    public ProductCoupon getProductCouponById(UUID id) {
        return productCouponRepository.findById(id).orElse(null);
    }

    @Override
    public ProductCoupon createProductCoupon(ProductCoupon productCoupon) {
        return productCouponRepository.save(productCoupon);
    }

    @Override
    public ProductCoupon updateProductCoupon(UUID id, ProductCoupon productCoupon) {
        ProductCoupon existing = productCouponRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setProduct(productCoupon.getProduct());
        existing.setCoupon(productCoupon.getCoupon());
        return productCouponRepository.save(existing);
    }

    @Override
    public void deleteProductCoupon(UUID id) {
        productCouponRepository.deleteById(id);
    }
}
