package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Variant;
import com.nguyenthiyenngoc.authapp.service.VariantService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/variants")
@CrossOrigin(origins = "*")
public class VariantController {

    private final VariantService variantService;

    public VariantController(VariantService variantService) {
        this.variantService = variantService;
    }

    @GetMapping
    public List<Variant> getAllVariants() {
        return variantService.getAllVariants();
    }

    @GetMapping("/{id}")
    public Variant getVariantById(@PathVariable UUID id) {
        return variantService.getVariantById(id);
    }

    @PostMapping
    public Variant createVariant(@RequestBody Variant variant) {
        return variantService.createVariant(variant);
    }

    @PutMapping("/{id}")
    public Variant updateVariant(
            @PathVariable UUID id,
            @RequestBody Variant variant) {
        return variantService.updateVariant(id, variant);
    }

    @DeleteMapping("/{id}")
    public void deleteVariant(@PathVariable UUID id) {
        variantService.deleteVariant(id);
    }
}
