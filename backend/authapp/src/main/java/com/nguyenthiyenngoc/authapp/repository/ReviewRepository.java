package com.nguyenthiyenngoc.authapp.repository;

import com.nguyenthiyenngoc.authapp.entity.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ReviewRepository extends JpaRepository<Review, UUID> {

    List<Review> findByProductIdOrderByCreatedAtDesc(UUID productId);

    @Query("SELECT r FROM Review r WHERE r.productId = :productId AND SIZE(r.images) > 0 ORDER BY r.createdAt DESC")
    List<Review> findByProductIdWithImages(@Param("productId") UUID productId);
}
