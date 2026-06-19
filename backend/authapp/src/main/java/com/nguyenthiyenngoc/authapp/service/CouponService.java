package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Coupon;

import java.util.List;
import java.util.UUID;

public interface CouponService {

    List<Coupon> getAllCoupons();

    Coupon getCouponById(UUID id);

    Coupon createCoupon(Coupon coupon);

    Coupon updateCoupon(UUID id, Coupon coupon);

    void deleteCoupon(UUID id);
}