package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.ProductShippingInfo;
import com.nguyenthiyenngoc.authapp.repository.ProductShippingInfoRepository;
import com.nguyenthiyenngoc.authapp.service.ProductShippingInfoService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class ProductShippingInfoServiceImpl implements ProductShippingInfoService {

    private final ProductShippingInfoRepository productShippingInfoRepository;

    public ProductShippingInfoServiceImpl(ProductShippingInfoRepository productShippingInfoRepository) {
        this.productShippingInfoRepository = productShippingInfoRepository;
    }

    @Override
    public List<ProductShippingInfo> getAllProductShippingInfos() {
        return productShippingInfoRepository.findAll();
    }

    @Override
    public ProductShippingInfo getProductShippingInfoById(UUID id) {
        return productShippingInfoRepository.findById(id).orElse(null);
    }

    @Override
    public ProductShippingInfo createProductShippingInfo(ProductShippingInfo productShippingInfo) {
        return productShippingInfoRepository.save(productShippingInfo);
    }

    @Override
    public ProductShippingInfo updateProductShippingInfo(UUID id, ProductShippingInfo productShippingInfo) {
        ProductShippingInfo existing = productShippingInfoRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setProduct(productShippingInfo.getProduct());
        existing.setWeight(productShippingInfo.getWeight());
        existing.setWeightUnit(productShippingInfo.getWeightUnit());
        existing.setVolume(productShippingInfo.getVolume());
        existing.setVolumeUnit(productShippingInfo.getVolumeUnit());
        existing.setDimensionWidth(productShippingInfo.getDimensionWidth());
        existing.setDimensionHeight(productShippingInfo.getDimensionHeight());
        existing.setDimensionDepth(productShippingInfo.getDimensionDepth());
        existing.setDimensionUnit(productShippingInfo.getDimensionUnit());
        return productShippingInfoRepository.save(existing);
    }

    @Override
    public void deleteProductShippingInfo(UUID id) {
        productShippingInfoRepository.deleteById(id);
    }
}
