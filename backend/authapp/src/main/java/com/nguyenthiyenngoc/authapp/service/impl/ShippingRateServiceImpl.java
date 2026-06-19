package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ShippingRate;
import com.nguyenthiyenngoc.authapp.repository.ShippingRateRepository;
import com.nguyenthiyenngoc.authapp.service.ShippingRateService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ShippingRateServiceImpl implements ShippingRateService {

    private final ShippingRateRepository shippingRateRepository;

    public ShippingRateServiceImpl(ShippingRateRepository shippingRateRepository) {
        this.shippingRateRepository = shippingRateRepository;
    }

    @Override
    public List<ShippingRate> getAllShippingRates() {
        return shippingRateRepository.findAll();
    }

    @Override
    public ShippingRate getShippingRateById(UUID id) {
        return shippingRateRepository.findById(id).orElse(null);
    }

    @Override
    public ShippingRate createShippingRate(ShippingRate shippingRate) {
        return shippingRateRepository.save(shippingRate);
    }

    @Override
    public ShippingRate updateShippingRate(UUID id, ShippingRate shippingRate) {
        ShippingRate existing = shippingRateRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setShippingZone(shippingRate.getShippingZone());
        existing.setWeightUnit(shippingRate.getWeightUnit());
        existing.setMinValue(shippingRate.getMinValue());
        existing.setMaxValue(shippingRate.getMaxValue());
        existing.setNoMax(shippingRate.getNoMax());
        existing.setPrice(shippingRate.getPrice());
        return shippingRateRepository.save(existing);
    }

    @Override
    public void deleteShippingRate(UUID id) {
        shippingRateRepository.deleteById(id);
    }
}
