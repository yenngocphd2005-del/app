package com.nguyenthiyenngoc.authapp.service;

import com.nguyenthiyenngoc.authapp.entity.Category;

import java.util.List;
import java.util.UUID;

public interface CategoryService {
    Category createCategory(Category category);
    Category getCategoryById(UUID id);
    List<Category> getAllCategories();
    List<Category> getRootCategories();
    List<Category> getCategoriesByParentId(UUID parentId);
    Category updateCategory(UUID id, Category category);
    void deleteCategory(UUID id);
}
