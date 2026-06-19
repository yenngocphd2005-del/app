package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ShippingCountryZone;
import com.nguyenthiyenngoc.authapp.repository.ShippingCountryZoneRepository;
import com.nguyenthiyenngoc.authapp.service.ShippingCountryZoneService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ShippingCountryZoneServiceImpl implements ShippingCountryZoneService {

    private final ShippingCountryZoneRepository shippingCountryZoneRepository;

    public ShippingCountryZoneServiceImpl(ShippingCountryZoneRepository shippingCountryZoneRepository) {
        this.shippingCountryZoneRepository = shippingCountryZoneRepository;
    }

    @Override
    public List<ShippingCountryZone> getAllShippingCountryZones() {
        return shippingCountryZoneRepository.findAll();
    }

    @Override
    public ShippingCountryZone getShippingCountryZoneById(UUID id) {
        return shippingCountryZoneRepository.findById(id).orElse(null);
    }

    @Override
    public ShippingCountryZone createShippingCountryZone(ShippingCountryZone shippingCountryZone) {
        return shippingCountryZoneRepository.save(shippingCountryZone);
    }

    @Override
    public ShippingCountryZone updateShippingCountryZone(UUID id, ShippingCountryZone shippingCountryZone) {
        ShippingCountryZone existing = shippingCountryZoneRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setShippingZone(shippingCountryZone.getShippingZone());
        existing.setCountry(shippingCountryZone.getCountry());
        return shippingCountryZoneRepository.save(existing);
    }

    @Override
    public void deleteShippingCountryZone(UUID id) {
        shippingCountryZoneRepository.deleteById(id);
    }
}
