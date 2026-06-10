package com.nguyenthiyenngoc.authapp.repository;

import com.nguyenthiyenngoc.authapp.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CategoryRepository extends JpaRepository<Category, UUID> {
    Optional<Category> findByCategoryNameIgnoreCase(String categoryName);
    List<Category> findByParentIsNullAndActiveTrue();
    List<Category> findByParent_IdAndActiveTrue(UUID parentId);
}
