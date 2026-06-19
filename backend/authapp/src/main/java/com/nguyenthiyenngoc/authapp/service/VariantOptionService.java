package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.VariantOption;

import java.util.List;
import java.util.UUID;

public interface VariantOptionService {

    List<VariantOption> getAllVariantOptions();

    VariantOption getVariantOptionById(UUID id);

    VariantOption createVariantOption(VariantOption variantOption);

    VariantOption updateVariantOption(UUID id, VariantOption variantOption);

    void deleteVariantOption(UUID id);
}
