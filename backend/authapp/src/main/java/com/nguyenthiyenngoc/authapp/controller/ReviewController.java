package com.nguyenthiyenngoc.authapp.controller;

import com.nguyenthiyenngoc.authapp.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {

    private final ReviewService reviewService;

    @Autowired
    public ReviewController(ReviewService reviewService) {
        this.reviewService = reviewService;
    }

    /**
     * GET /api/reviews/product/{productId}
     * GET /api/reviews/product/{productId}?withPhoto=true
     */
    @GetMapping("/product/{productId}")
    public ResponseEntity<List<Map<String, Object>>> getReviewsByProduct(
            @PathVariable UUID productId,
            @RequestParam(value = "withPhoto", defaultValue = "false") boolean withPhoto) {
        return ResponseEntity.ok(reviewService.getReviewsByProductId(productId, withPhoto));
    }

    /**
     * GET /api/reviews/product/{productId}/summary
     */
    @GetMapping("/product/{productId}/summary")
    public ResponseEntity<Map<String, Object>> getRatingSummary(@PathVariable UUID productId) {
        return ResponseEntity.ok(reviewService.getRatingSummary(productId));
    }

    /**
     * POST /api/reviews
     * Content-Type: multipart/form-data
     */
    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<Map<String, Object>> createReview(
            @RequestParam("productId") UUID productId,
            @RequestParam("userId") UUID userId,
            @RequestParam("rating") int rating,
            @RequestParam(value = "comment", required = false, defaultValue = "") String comment,
            @RequestParam(value = "images", required = false) List<MultipartFile> images) {

        Map<String, Object> result = reviewService.createReview(productId, userId, rating, comment, images);
        return ResponseEntity.ok(result);
    }
}
