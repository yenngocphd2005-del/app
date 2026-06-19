package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ShippingZone;
import com.nguyenthiyenngoc.authapp.service.ShippingZoneService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/shipping-zones")
@CrossOrigin(origins = "*")
public class ShippingZoneController {

    private final ShippingZoneService shippingZoneService;

    public ShippingZoneController(
            ShippingZoneService shippingZoneService) {
        this.shippingZoneService = shippingZoneService;
    }

    @GetMapping
    public List<ShippingZone> getAllShippingZones() {
        return shippingZoneService.getAllShippingZones();
    }

    @GetMapping("/{id}")
    public ShippingZone getShippingZoneById(
            @PathVariable UUID id) {
        return shippingZoneService.getShippingZoneById(id);
    }

    @PostMapping
    public ShippingZone createShippingZone(
            @RequestBody ShippingZone shippingZone) {
        return shippingZoneService.createShippingZone(shippingZone);
    }

    @PutMapping("/{id}")
    public ShippingZone updateShippingZone(
            @PathVariable UUID id,
            @RequestBody ShippingZone shippingZone) {

        return shippingZoneService.updateShippingZone(id, shippingZone);
    }

    @DeleteMapping("/{id}")
    public void deleteShippingZone(
            @PathVariable UUID id) {
        shippingZoneService.deleteShippingZone(id);
    }
}