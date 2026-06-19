package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.VariantOption;
import com.nguyenthiyenngoc.authapp.service.VariantOptionService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/variant-options")
@CrossOrigin(origins = "*")
public class VariantOptionController {

    private final VariantOptionService variantOptionService;

    public VariantOptionController(VariantOptionService variantOptionService) {
        this.variantOptionService = variantOptionService;
    }

    @GetMapping
    public List<VariantOption> getAllVariantOptions() {
        return variantOptionService.getAllVariantOptions();
    }

    @GetMapping("/{id}")
    public VariantOption getVariantOptionById(@PathVariable UUID id) {
        return variantOptionService.getVariantOptionById(id);
    }

    @PostMapping
    public VariantOption createVariantOption(@RequestBody VariantOption variantOption) {
        return variantOptionService.createVariantOption(variantOption);
    }

    @PutMapping("/{id}")
    public VariantOption updateVariantOption(
            @PathVariable UUID id,
            @RequestBody VariantOption variantOption) {
        return variantOptionService.updateVariantOption(id, variantOption);
    }

    @DeleteMapping("/{id}")
    public void deleteVariantOption(@PathVariable UUID id) {
        variantOptionService.deleteVariantOption(id);
    }
}
