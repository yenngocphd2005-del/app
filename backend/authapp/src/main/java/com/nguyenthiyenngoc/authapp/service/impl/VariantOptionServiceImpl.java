package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.VariantOption;
import com.nguyenthiyenngoc.authapp.repository.VariantOptionRepository;
import com.nguyenthiyenngoc.authapp.service.VariantOptionService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class VariantOptionServiceImpl implements VariantOptionService {

    private final VariantOptionRepository variantOptionRepository;

    public VariantOptionServiceImpl(VariantOptionRepository variantOptionRepository) {
        this.variantOptionRepository = variantOptionRepository;
    }

    @Override
    public List<VariantOption> getAllVariantOptions() {
        return variantOptionRepository.findAll();
    }

    @Override
    public VariantOption getVariantOptionById(UUID id) {
        return variantOptionRepository.findById(id).orElse(null);
    }

    @Override
    public VariantOption createVariantOption(VariantOption variantOption) {
        return variantOptionRepository.save(variantOption);
    }

    @Override
    public VariantOption updateVariantOption(UUID id, VariantOption variantOption) {
        VariantOption existing = variantOptionRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setTitle(variantOption.getTitle());
        existing.setImage(variantOption.getImage());
        existing.setProduct(variantOption.getProduct());
        existing.setSalePrice(variantOption.getSalePrice());
        existing.setComparePrice(variantOption.getComparePrice());
        existing.setBuyingPrice(variantOption.getBuyingPrice());
        existing.setQuantity(variantOption.getQuantity());
        existing.setSku(variantOption.getSku());
        existing.setActive(variantOption.getActive());
        return variantOptionRepository.save(existing);
    }

    @Override
    public void deleteVariantOption(UUID id) {
        variantOptionRepository.deleteById(id);
    }
}
