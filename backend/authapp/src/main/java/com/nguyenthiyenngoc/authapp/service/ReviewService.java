package com.nguyenthiyenngoc.authapp.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface ReviewService {

    List<Map<String, Object>> getReviewsByProductId(UUID productId, boolean withPhoto);

    Map<String, Object> getRatingSummary(UUID productId);

    Map<String, Object> createReview(UUID productId, UUID userId, int rating, String comment, List<MultipartFile> images);
}
