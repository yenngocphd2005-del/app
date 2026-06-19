package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.AttributeValue;
import com.nguyenthiyenngoc.authapp.repository.AttributeValueRepository;
import com.nguyenthiyenngoc.authapp.service.AttributeValueService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class AttributeValueServiceImpl implements AttributeValueService {

    private final AttributeValueRepository attributeValueRepository;

    public AttributeValueServiceImpl(AttributeValueRepository attributeValueRepository) {
        this.attributeValueRepository = attributeValueRepository;
    }

    @Override
    public List<AttributeValue> getAllAttributeValues() {
        return attributeValueRepository.findAll();
    }

    @Override
    public AttributeValue getAttributeValueById(UUID id) {
        return attributeValueRepository.findById(id).orElse(null);
    }

    @Override
    public AttributeValue createAttributeValue(AttributeValue attributeValue) {
        return attributeValueRepository.save(attributeValue);
    }

    @Override
    public AttributeValue updateAttributeValue(UUID id, AttributeValue attributeValue) {
        AttributeValue existing = attributeValueRepository.findById(id).orElse(null);
        if (existing == null) {
            return null;
        }
        existing.setAttribute(attributeValue.getAttribute());
        existing.setAttributeValue(attributeValue.getAttributeValue());
        existing.setColor(attributeValue.getColor());
        return attributeValueRepository.save(existing);
    }

    @Override
    public void deleteAttributeValue(UUID id) {
        attributeValueRepository.deleteById(id);
    }
}
