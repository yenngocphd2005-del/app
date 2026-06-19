package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.ShippingZone;

import java.util.List;
import java.util.UUID;

public interface ShippingZoneService {

    List<ShippingZone> getAllShippingZones();

    ShippingZone getShippingZoneById(UUID id);

    ShippingZone createShippingZone(ShippingZone shippingZone);

    ShippingZone updateShippingZone(UUID id, ShippingZone shippingZone);

    void deleteShippingZone(UUID id);
}