package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.VariantValue;

import java.util.List;
import java.util.UUID;

public interface VariantValueService {

    List<VariantValue> getAllVariantValues();

    VariantValue getVariantValueById(UUID id);

    VariantValue createVariantValue(VariantValue variantValue);

    VariantValue updateVariantValue(UUID id, VariantValue variantValue);

    void deleteVariantValue(UUID id);
}
