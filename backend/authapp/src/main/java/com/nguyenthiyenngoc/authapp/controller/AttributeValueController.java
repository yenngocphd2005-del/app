package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.AttributeValue;
import com.nguyenthiyenngoc.authapp.service.AttributeValueService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/attribute-values")
@CrossOrigin(origins = "*")
public class AttributeValueController {

    private final AttributeValueService attributeValueService;

    public AttributeValueController(AttributeValueService attributeValueService) {
        this.attributeValueService = attributeValueService;
    }

    @GetMapping
    public List<AttributeValue> getAllAttributeValues() {
        return attributeValueService.getAllAttributeValues();
    }

    @GetMapping("/{id}")
    public AttributeValue getAttributeValueById(@PathVariable UUID id) {
        return attributeValueService.getAttributeValueById(id);
    }

    @PostMapping
    public AttributeValue createAttributeValue(@RequestBody AttributeValue attributeValue) {
        return attributeValueService.createAttributeValue(attributeValue);
    }

    @PutMapping("/{id}")
    public AttributeValue updateAttributeValue(
            @PathVariable UUID id,
            @RequestBody AttributeValue attributeValue) {
        return attributeValueService.updateAttributeValue(id, attributeValue);
    }

    @DeleteMapping("/{id}")
    public void deleteAttributeValue(@PathVariable UUID id) {
        attributeValueService.deleteAttributeValue(id);
    }
}
