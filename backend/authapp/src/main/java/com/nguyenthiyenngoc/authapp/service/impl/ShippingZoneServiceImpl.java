package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ShippingZone;
import com.nguyenthiyenngoc.authapp.repository.ShippingZoneRepository;
import com.nguyenthiyenngoc.authapp.service.ShippingZoneService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ShippingZoneServiceImpl implements ShippingZoneService {

    private final ShippingZoneRepository shippingZoneRepository;

    public ShippingZoneServiceImpl(
            ShippingZoneRepository shippingZoneRepository) {
        this.shippingZoneRepository = shippingZoneRepository;
    }

    @Override
    public List<ShippingZone> getAllShippingZones() {
        return shippingZoneRepository.findAll();
    }

    @Override
    public ShippingZone getShippingZoneById(UUID id) {
        return shippingZoneRepository.findById(id).orElse(null);
    }

    @Override
    public ShippingZone createShippingZone(
            ShippingZone shippingZone) {
        return shippingZoneRepository.save(shippingZone);
    }

    @Override
    public ShippingZone updateShippingZone(
            UUID id,
            ShippingZone shippingZone) {

        ShippingZone existing =
                shippingZoneRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setName(shippingZone.getName());
        existing.setDisplayName(shippingZone.getDisplayName());
        existing.setActive(shippingZone.getActive());
        existing.setFreeShipping(shippingZone.getFreeShipping());
        existing.setRateType(shippingZone.getRateType());
        existing.setCreatedBy(shippingZone.getCreatedBy());
        existing.setUpdatedBy(shippingZone.getUpdatedBy());

        return shippingZoneRepository.save(existing);
    }

    @Override
    public void deleteShippingZone(UUID id) {
        shippingZoneRepository.deleteById(id);
    }
}