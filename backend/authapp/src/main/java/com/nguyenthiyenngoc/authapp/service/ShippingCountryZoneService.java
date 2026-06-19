package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ShippingCountryZone;

import java.util.List;
import java.util.UUID;

public interface ShippingCountryZoneService {

    List<ShippingCountryZone> getAllShippingCountryZones();

    ShippingCountryZone getShippingCountryZoneById(UUID id);

    ShippingCountryZone createShippingCountryZone(ShippingCountryZone shippingCountryZone);

    ShippingCountryZone updateShippingCountryZone(UUID id, ShippingCountryZone shippingCountryZone);

    void deleteShippingCountryZone(UUID id);
}
