package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Coupon;
import com.nguyenthiyenngoc.authapp.repository.CouponRepository;
import com.nguyenthiyenngoc.authapp.service.CouponService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CouponServiceImpl implements CouponService {

    private final CouponRepository couponRepository;

    public CouponServiceImpl(CouponRepository couponRepository) {
        this.couponRepository = couponRepository;
    }

    @Override
    public List<Coupon> getAllCoupons() {
        return couponRepository.findAll();
    }

    @Override
    public Coupon getCouponById(UUID id) {
        return couponRepository.findById(id).orElse(null);
    }

    @Override
    public Coupon createCoupon(Coupon coupon) {
        return couponRepository.save(coupon);
    }

    @Override
    public Coupon updateCoupon(UUID id, Coupon coupon) {

        Coupon existing =
                couponRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setCode(coupon.getCode());
        existing.setDiscountValue(coupon.getDiscountValue());
        existing.setDiscountType(coupon.getDiscountType());
        existing.setTimesUsed(coupon.getTimesUsed());
        existing.setMaxUsage(coupon.getMaxUsage());
        existing.setOrderAmountLimit(coupon.getOrderAmountLimit());
        existing.setCouponStartDate(coupon.getCouponStartDate());
        existing.setCouponEndDate(coupon.getCouponEndDate());

        return couponRepository.save(existing);
    }

    @Override
    public void deleteCoupon(UUID id) {
        couponRepository.deleteById(id);
    }
}