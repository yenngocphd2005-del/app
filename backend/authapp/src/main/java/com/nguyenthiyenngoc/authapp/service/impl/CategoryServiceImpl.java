package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Category;
import com.nguyenthiyenngoc.authapp.repository.CategoryRepository;
import com.nguyenthiyenngoc.authapp.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    @Autowired
    public CategoryServiceImpl(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    @Override
    public Category createCategory(Category category) {
        if (categoryRepository.findByCategoryNameIgnoreCase(category.getCategoryName()).isPresent()) {
            throw new RuntimeException("Category with name already exists: " + category.getCategoryName());
        }
        return categoryRepository.save(category);
    }

    @Override
    public Category getCategoryById(UUID id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found with ID: " + id));
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public List<Category> getRootCategories() {
        return categoryRepository.findByParentIsNullAndActiveTrue();
    }

    @Override
    public List<Category> getCategoriesByParentId(UUID parentId) {
        Category parent = categoryRepository.findById(parentId).orElse(null);
        if (parent != null) {
            String name = parent.getCategoryName();
            if ("New".equalsIgnoreCase(name) || "Shoes".equalsIgnoreCase(name) || "Accessories".equalsIgnoreCase(name)) {
                Category clothes = categoryRepository.findByCategoryNameIgnoreCase("Clothes").orElse(null);
                if (clothes != null) {
                    return categoryRepository.findByParent_IdAndActiveTrue(clothes.getId());
                }
            }
        }
        return categoryRepository.findByParent_IdAndActiveTrue(parentId);
    }

    @Override
    public Category updateCategory(UUID id, Category category) {
        Category existing = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found with ID: " + id));

        existing.setCategoryName(category.getCategoryName());
        existing.setCategoryDescription(category.getCategoryDescription());
        existing.setParent(category.getParent());
        existing.setIcon(category.getIcon());
        existing.setImage(category.getImage());
        existing.setPlaceholder(category.getPlaceholder());
        existing.setActive(category.getActive());

        return categoryRepository.save(existing);
    }

    @Override
    public void deleteCategory(UUID id) {
        categoryRepository.deleteById(id);
    }
}
