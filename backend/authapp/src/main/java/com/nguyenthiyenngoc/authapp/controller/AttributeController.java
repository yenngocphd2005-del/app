package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.entity.Attribute;
import com.nguyenthiyenngoc.authapp.service.AttributeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/attributes")
@CrossOrigin(origins = "*")
public class AttributeController {

    private final AttributeService attributeService;

    public AttributeController(AttributeService attributeService) {
        this.attributeService = attributeService;
    }

    @GetMapping
    public List<Attribute> getAllAttributes() {
        return attributeService.getAllAttributes();
    }

    @GetMapping("/{id}")
    public Attribute getAttributeById(@PathVariable UUID id) {
        return attributeService.getAttributeById(id);
    }

    @PostMapping
    public Attribute createAttribute(@RequestBody Attribute attribute) {
        return attributeService.createAttribute(attribute);
    }

    @PutMapping("/{id}")
    public Attribute updateAttribute(
            @PathVariable UUID id,
            @RequestBody Attribute attribute) {

        return attributeService.updateAttribute(id, attribute);
    }

    @DeleteMapping("/{id}")
    public void deleteAttribute(@PathVariable UUID id) {
        attributeService.deleteAttribute(id);
    }
}