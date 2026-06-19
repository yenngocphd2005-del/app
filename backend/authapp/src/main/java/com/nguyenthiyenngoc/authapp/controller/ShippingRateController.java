package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ShippingRate;
import com.nguyenthiyenngoc.authapp.service.ShippingRateService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/shipping-rates")
@CrossOrigin(origins = "*")
public class ShippingRateController {

    private final ShippingRateService shippingRateService;

    public ShippingRateController(ShippingRateService shippingRateService) {
        this.shippingRateService = shippingRateService;
    }

    @GetMapping
    public List<ShippingRate> getAllShippingRates() {
        return shippingRateService.getAllShippingRates();
    }

    @GetMapping("/{id}")
    public ShippingRate getShippingRateById(@PathVariable UUID id) {
        return shippingRateService.getShippingRateById(id);
    }

    @PostMapping
    public ShippingRate createShippingRate(@RequestBody ShippingRate shippingRate) {
        return shippingRateService.createShippingRate(shippingRate);
    }

    @PutMapping("/{id}")
    public ShippingRate updateShippingRate(
            @PathVariable UUID id,
            @RequestBody ShippingRate shippingRate) {
        return shippingRateService.updateShippingRate(id, shippingRate);
    }

    @DeleteMapping("/{id}")
    public void deleteShippingRate(@PathVariable UUID id) {
        shippingRateService.deleteShippingRate(id);
    }
}
