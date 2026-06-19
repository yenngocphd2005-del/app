package com.nguyenthiyenngoc.authapp.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.OffsetDateTime;
import java.util.UUID;

@Entity
@Table(name = "coupons")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Coupon {

    @Id
    @GeneratedValue
    private UUID id;

    @Column(nullable = false, unique = true, length = 50)
    private String code;

    @Column(name = "discount_value")
    private BigDecimal discountValue;

    @Column(name = "discount_type", nullable = false, length = 50)
    private String discountType;

    @Column(name = "times_used")
    @Builder.Default
    private Integer timesUsed = 0;

    @Column(name = "max_usage")
    private Integer maxUsage;

    @Column(name = "order_amount_limit")
    private BigDecimal orderAmountLimit;

    @Column(name = "coupon_start_date")
    private OffsetDateTime couponStartDate;

    @Column(name = "coupon_end_date")
    private OffsetDateTime couponEndDate;
}