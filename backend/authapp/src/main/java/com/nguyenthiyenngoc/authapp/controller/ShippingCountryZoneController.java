package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ShippingCountryZone;
import com.nguyenthiyenngoc.authapp.service.ShippingCountryZoneService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/shipping-country-zones")
@CrossOrigin(origins = "*")
public class ShippingCountryZoneController {

    private final ShippingCountryZoneService shippingCountryZoneService;

    public ShippingCountryZoneController(ShippingCountryZoneService shippingCountryZoneService) {
        this.shippingCountryZoneService = shippingCountryZoneService;
    }

    @GetMapping
    public List<ShippingCountryZone> getAllShippingCountryZones() {
        return shippingCountryZoneService.getAllShippingCountryZones();
    }

    @GetMapping("/{id}")
    public ShippingCountryZone getShippingCountryZoneById(@PathVariable UUID id) {
        return shippingCountryZoneService.getShippingCountryZoneById(id);
    }

    @PostMapping
    public ShippingCountryZone createShippingCountryZone(@RequestBody ShippingCountryZone shippingCountryZone) {
        return shippingCountryZoneService.createShippingCountryZone(shippingCountryZone);
    }

    @PutMapping("/{id}")
    public ShippingCountryZone updateShippingCountryZone(
            @PathVariable UUID id,
            @RequestBody ShippingCountryZone shippingCountryZone) {
        return shippingCountryZoneService.updateShippingCountryZone(id, shippingCountryZone);
    }

    @DeleteMapping("/{id}")
    public void deleteShippingCountryZone(@PathVariable UUID id) {
        shippingCountryZoneService.deleteShippingCountryZone(id);
    }
}
