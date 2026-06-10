package com.nguyenthiyenngoc.authapp.repository;

import com.nguyenthiyenngoc.authapp.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface ProductRepository extends JpaRepository<Product, UUID> {
    Optional<Product> findBySlug(String slug);
    List<Product> findByTagsTagNameIgnoreCase(String tagName);
    List<Product> findByCategoriesId(UUID categoryId);
    List<Product> findByCategoriesCategoryNameIgnoreCase(String categoryName);
    List<Product> findTop20ByPublishedTrueOrderByCreatedAtDesc();
}
