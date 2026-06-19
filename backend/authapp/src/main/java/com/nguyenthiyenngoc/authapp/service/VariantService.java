package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Variant;

import java.util.List;
import java.util.UUID;

public interface VariantService {

    List<Variant> getAllVariants();

    Variant getVariantById(UUID id);

    Variant createVariant(Variant variant);

    Variant updateVariant(UUID id, Variant variant);

    void deleteVariant(UUID id);
}
