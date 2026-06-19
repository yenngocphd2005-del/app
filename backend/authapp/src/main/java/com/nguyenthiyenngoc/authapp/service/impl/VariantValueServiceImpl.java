package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.VariantValue;
import com.nguyenthiyenngoc.authapp.repository.VariantValueRepository;
import com.nguyenthiyenngoc.authapp.service.VariantValueService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class VariantValueServiceImpl implements VariantValueService {

    private final VariantValueRepository variantValueRepository;

    public VariantValueServiceImpl(VariantValueRepository variantValueRepository) {
        this.variantValueRepository = variantValueRepository;
    }

    @Override
    public List<VariantValue> getAllVariantValues() {
        return variantValueRepository.findAll();
    }

    @Override
    public VariantValue getVariantValueById(UUID id) {
        return variantValueRepository.findById(id).orElse(null);
    }

    @Override
    public VariantValue createVariantValue(VariantValue variantValue) {
        return variantValueRepository.save(variantValue);
    }

    @Override
    public VariantValue updateVariantValue(UUID id, VariantValue variantValue) {
        VariantValue existing = variantValueRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setVariant(variantValue.getVariant());
        existing.setProductAttributeValue(variantValue.getProductAttributeValue());
        return variantValueRepository.save(existing);
    }

    @Override
    public void deleteVariantValue(UUID id) {
        variantValueRepository.deleteById(id);
    }
}
