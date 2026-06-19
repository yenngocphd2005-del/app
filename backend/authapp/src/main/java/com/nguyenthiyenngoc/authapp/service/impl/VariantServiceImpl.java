package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Variant;
import com.nguyenthiyenngoc.authapp.repository.VariantRepository;
import com.nguyenthiyenngoc.authapp.service.VariantService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class VariantServiceImpl implements VariantService {

    private final VariantRepository variantRepository;

    public VariantServiceImpl(VariantRepository variantRepository) {
        this.variantRepository = variantRepository;
    }

    @Override
    public List<Variant> getAllVariants() {
        return variantRepository.findAll();
    }

    @Override
    public Variant getVariantById(UUID id) {
        return variantRepository.findById(id).orElse(null);
    }

    @Override
    public Variant createVariant(Variant variant) {
        return variantRepository.save(variant);
    }

    @Override
    public Variant updateVariant(UUID id, Variant variant) {
        Variant existing = variantRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setVariantOption(variant.getVariantOption());
        existing.setProduct(variant.getProduct());
        existing.setVariantOptionRef(variant.getVariantOptionRef());
        return variantRepository.save(existing);
    }

    @Override
    public void deleteVariant(UUID id) {
        variantRepository.deleteById(id);
    }
}
