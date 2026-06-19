package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.ProductShippingInfo;
import com.nguyenthiyenngoc.authapp.service.ProductShippingInfoService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/product-shipping-info")
@CrossOrigin(origins = "*")
public class ProductShippingInfoController {

    private final ProductShippingInfoService productShippingInfoService;

    public ProductShippingInfoController(ProductShippingInfoService productShippingInfoService) {
        this.productShippingInfoService = productShippingInfoService;
    }

    @GetMapping
    public List<ProductShippingInfo> getAllProductShippingInfos() {
        return productShippingInfoService.getAllProductShippingInfos();
    }

    @GetMapping("/{id}")
    public ProductShippingInfo getProductShippingInfoById(@PathVariable UUID id) {
        return productShippingInfoService.getProductShippingInfoById(id);
    }

    @PostMapping
    public ProductShippingInfo createProductShippingInfo(@RequestBody ProductShippingInfo productShippingInfo) {
        return productShippingInfoService.createProductShippingInfo(productShippingInfo);
    }

    @PutMapping("/{id}")
    public ProductShippingInfo updateProductShippingInfo(
            @PathVariable UUID id,
            @RequestBody ProductShippingInfo productShippingInfo) {
        return productShippingInfoService.updateProductShippingInfo(id, productShippingInfo);
    }

    @DeleteMapping("/{id}")
    public void deleteProductShippingInfo(@PathVariable UUID id) {
        productShippingInfoService.deleteProductShippingInfo(id);
    }
}
