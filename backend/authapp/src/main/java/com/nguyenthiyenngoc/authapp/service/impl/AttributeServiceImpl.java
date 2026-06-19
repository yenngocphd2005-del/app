package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Attribute;
import com.nguyenthiyenngoc.authapp.repository.AttributeRepository;
import com.nguyenthiyenngoc.authapp.service.AttributeService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class AttributeServiceImpl implements AttributeService {

    private final AttributeRepository attributeRepository;

    public AttributeServiceImpl(AttributeRepository attributeRepository) {
        this.attributeRepository = attributeRepository;
    }

    @Override
    public List<Attribute> getAllAttributes() {
        return attributeRepository.findAll();
    }

    @Override
    public Attribute getAttributeById(UUID id) {
        return attributeRepository.findById(id).orElse(null);
    }

    @Override
    public Attribute createAttribute(Attribute attribute) {
        return attributeRepository.save(attribute);
    }

    @Override
    public Attribute updateAttribute(UUID id, Attribute attribute) {

        Attribute existing =
                attributeRepository.findById(id).orElse(null);

        if (existing == null) {
            return null;
        }

        existing.setAttributeName(attribute.getAttributeName());
        existing.setCreatedBy(attribute.getCreatedBy());
        existing.setUpdatedBy(attribute.getUpdatedBy());

        return attributeRepository.save(existing);
    }

    @Override
    public void deleteAttribute(UUID id) {
        attributeRepository.deleteById(id);
    }
}