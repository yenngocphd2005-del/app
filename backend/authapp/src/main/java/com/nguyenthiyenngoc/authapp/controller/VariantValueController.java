package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.VariantValue;
import com.nguyenthiyenngoc.authapp.service.VariantValueService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/variant-values")
@CrossOrigin(origins = "*")
public class VariantValueController {

    private final VariantValueService variantValueService;

    public VariantValueController(VariantValueService variantValueService) {
        this.variantValueService = variantValueService;
    }

    @GetMapping
    public List<VariantValue> getAllVariantValues() {
        return variantValueService.getAllVariantValues();
    }

    @GetMapping("/{id}")
    public VariantValue getVariantValueById(@PathVariable UUID id) {
        return variantValueService.getVariantValueById(id);
    }

    @PostMapping
    public VariantValue createVariantValue(@RequestBody VariantValue variantValue) {
        return variantValueService.createVariantValue(variantValue);
    }

    @PutMapping("/{id}")
    public VariantValue updateVariantValue(
            @PathVariable UUID id,
            @RequestBody VariantValue variantValue) {
        return variantValueService.updateVariantValue(id, variantValue);
    }

    @DeleteMapping("/{id}")
    public void deleteVariantValue(@PathVariable UUID id) {
        variantValueService.deleteVariantValue(id);
    }
}
