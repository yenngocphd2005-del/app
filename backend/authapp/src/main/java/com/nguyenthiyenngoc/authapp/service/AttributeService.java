package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Attribute;

import java.util.List;
import java.util.UUID;

public interface AttributeService {

    List<Attribute> getAllAttributes();

    Attribute getAttributeById(UUID id);

    Attribute createAttribute(Attribute attribute);

    Attribute updateAttribute(UUID id, Attribute attribute);

    void deleteAttribute(UUID id);
}