package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ProductCoupon;
import com.nguyenthiyenngoc.authapp.service.ProductCouponService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/product-coupons")
@CrossOrigin(origins = "*")
public class ProductCouponController {

    private final ProductCouponService productCouponService;

    public ProductCouponController(ProductCouponService productCouponService) {
        this.productCouponService = productCouponService;
    }

    @GetMapping
    public List<ProductCoupon> getAllProductCoupons() {
        return productCouponService.getAllProductCoupons();
    }

    @GetMapping("/{id}")
    public ProductCoupon getProductCouponById(@PathVariable UUID id) {
        return productCouponService.getProductCouponById(id);
    }

    @PostMapping
    public ProductCoupon createProductCoupon(@RequestBody ProductCoupon productCoupon) {
        return productCouponService.createProductCoupon(productCoupon);
    }

    @PutMapping("/{id}")
    public ProductCoupon updateProductCoupon(
            @PathVariable UUID id,
            @RequestBody ProductCoupon productCoupon) {
        return productCouponService.updateProductCoupon(id, productCoupon);
    }

    @DeleteMapping("/{id}")
    public void deleteProductCoupon(@PathVariable UUID id) {
        productCouponService.deleteProductCoupon(id);
    }
}
