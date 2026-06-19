package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ShippingRate;

import java.util.List;
import java.util.UUID;

public interface ShippingRateService {

    List<ShippingRate> getAllShippingRates();

    ShippingRate getShippingRateById(UUID id);

    ShippingRate createShippingRate(ShippingRate shippingRate);

    ShippingRate updateShippingRate(UUID id, ShippingRate shippingRate);

    void deleteShippingRate(UUID id);
}
