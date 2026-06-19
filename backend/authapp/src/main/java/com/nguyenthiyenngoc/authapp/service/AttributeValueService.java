package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.AttributeValue;

import java.util.List;
import java.util.UUID;

public interface AttributeValueService {

    List<AttributeValue> getAllAttributeValues();

    AttributeValue getAttributeValueById(UUID id);

    AttributeValue createAttributeValue(AttributeValue attributeValue);

    AttributeValue updateAttributeValue(UUID id, AttributeValue attributeValue);

    void deleteAttributeValue(UUID id);
}
