package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Coupon;
import com.nguyenthiyenngoc.authapp.service.CouponService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/coupons")
@CrossOrigin(origins = "*")
public class CouponController {

    private final CouponService couponService;

    public CouponController(CouponService couponService) {
        this.couponService = couponService;
    }

    @GetMapping
    public List<Coupon> getAllCoupons() {
        return couponService.getAllCoupons();
    }

    @GetMapping("/{id}")
    public Coupon getCouponById(@PathVariable UUID id) {
        return couponService.getCouponById(id);
    }

    @PostMapping
    public Coupon createCoupon(@RequestBody Coupon coupon) {
        return couponService.createCoupon(coupon);
    }

    @PutMapping("/{id}")
    public Coupon updateCoupon(
            @PathVariable UUID id,
            @RequestBody Coupon coupon) {

        return couponService.updateCoupon(id, coupon);
    }

    @DeleteMapping("/{id}")
    public void deleteCoupon(@PathVariable UUID id) {
        couponService.deleteCoupon(id);
    }
}