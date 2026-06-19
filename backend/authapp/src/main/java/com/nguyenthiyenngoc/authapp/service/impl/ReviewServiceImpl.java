package com.nguyenthiyenngoc.authapp.service.impl;

import com.nguyenthiyenngoc.authapp.entity.Review;
import com.nguyenthiyenngoc.authapp.entity.ReviewImage;
import com.nguyenthiyenngoc.authapp.repository.ReviewImageRepository;
import com.nguyenthiyenngoc.authapp.repository.ReviewRepository;
import com.nguyenthiyenngoc.authapp.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final ReviewImageRepository reviewImageRepository;

    private static final String UPLOAD_DIR = "uploads/reviews/";
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM d, yyyy");

    @Autowired
    public ReviewServiceImpl(ReviewRepository reviewRepository, ReviewImageRepository reviewImageRepository) {
        this.reviewRepository = reviewRepository;
        this.reviewImageRepository = reviewImageRepository;
    }

    @Override
    public List<Map<String, Object>> getReviewsByProductId(UUID productId, boolean withPhoto) {
        List<Review> reviews;
        if (withPhoto) {
            reviews = reviewRepository.findByProductIdWithImages(productId);
        } else {
            reviews = reviewRepository.findByProductIdOrderByCreatedAtDesc(productId);
        }
        List<Map<String, Object>> result = new ArrayList<>();
        for (Review r : reviews) {
            result.add(mapReview(r));
        }
        return result;
    }

    @Override
    public Map<String, Object> getRatingSummary(UUID productId) {
        List<Review> reviews = reviewRepository.findByProductIdOrderByCreatedAtDesc(productId);

        int total = reviews.size();
        int[] counts = new int[6]; // index 1-5
        double sum = 0;

        for (Review r : reviews) {
            int rating = r.getRating();
            if (rating >= 1 && rating <= 5) {
                counts[rating]++;
                sum += rating;
            }
        }

        double avg = total > 0 ? Math.round((sum / total) * 10.0) / 10.0 : 0.0;

        Map<String, Object> summary = new LinkedHashMap<>();
        summary.put("averageRating", avg);
        summary.put("totalReviews", total);
        summary.put("fiveStar", counts[5]);
        summary.put("fourStar", counts[4]);
        summary.put("threeStar", counts[3]);
        summary.put("twoStar", counts[2]);
        summary.put("oneStar", counts[1]);
        return summary;
    }

    @Override
    @Transactional
    public Map<String, Object> createReview(UUID productId, UUID userId, int rating, String comment, List<MultipartFile> images) {

        if (reviewRepository.existsByUserIdAndProductId(
        userId,
        productId)) {

            throw new RuntimeException(
                    "You have already reviewed this product");
        }
        // Build review entity
        Review review = Review.builder()
                .productId(productId)
                .userId(userId)
                .rating(rating)
                .comment(comment)
                .build();

        // Lưu review trước để có ID
        Review saved = reviewRepository.save(review);

        // Upload ảnh và lưu vào bảng review_image
        if (images != null) {
            for (MultipartFile file : images) {
                if (file != null && !file.isEmpty()) {
                    String imageUrl = saveImage(file);
                    ReviewImage img = ReviewImage.builder()
                            .review(saved)
                            .imageUrl(imageUrl)
                            .build();
                    reviewImageRepository.save(img);
                    saved.getImages().add(img);
                }
            }
        }

        return mapReview(saved);
    }

    private String saveImage(MultipartFile file) {
        try {
            // Tạo thư mục nếu chưa tồn tại
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Tạo tên file unique
            String originalFilename = file.getOriginalFilename();
            String extension = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String filename = UUID.randomUUID().toString() + extension;
            Path filePath = uploadPath.resolve(filename);

            Files.write(filePath, file.getBytes());

            return "/" + UPLOAD_DIR + filename;
        } catch (IOException e) {
            throw new RuntimeException("Failed to save image: " + e.getMessage(), e);
        }
    }

    private Map<String, Object> mapReview(Review review) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", review.getId().toString());
        map.put("productId", review.getProductId().toString());
        map.put("userId", review.getUserId().toString());
        map.put("rating", review.getRating());
        map.put("comment", review.getComment());
        map.put("createdAt", review.getCreatedAt() != null
                ? review.getCreatedAt().format(DATE_FORMATTER)
                : null);

        List<String> imageUrls = new ArrayList<>();
        if (review.getImages() != null) {
            for (ReviewImage img : review.getImages()) {
                imageUrls.add(img.getImageUrl());
            }
        }
        map.put("images", imageUrls);
        return map;
    }
}
