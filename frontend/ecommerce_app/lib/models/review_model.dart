class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final int rating;
  final String? comment;
  final String? createdAt;
  final List<String> images;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    required this.images,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id']?.toString() ?? '',
      productId: map['productId']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      comment: map['comment']?.toString(),
      createdAt: map['createdAt']?.toString(),
      images: (map['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ReviewSummaryModel {
  final double averageRating;
  final int totalReviews;
  final int fiveStar;
  final int fourStar;
  final int threeStar;
  final int twoStar;
  final int oneStar;

  ReviewSummaryModel({
    required this.averageRating,
    required this.totalReviews,
    required this.fiveStar,
    required this.fourStar,
    required this.threeStar,
    required this.twoStar,
    required this.oneStar,
  });

  factory ReviewSummaryModel.fromMap(Map<String, dynamic> map) {
    return ReviewSummaryModel(
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (map['totalReviews'] as num?)?.toInt() ?? 0,
      fiveStar: (map['fiveStar'] as num?)?.toInt() ?? 0,
      fourStar: (map['fourStar'] as num?)?.toInt() ?? 0,
      threeStar: (map['threeStar'] as num?)?.toInt() ?? 0,
      twoStar: (map['twoStar'] as num?)?.toInt() ?? 0,
      oneStar: (map['oneStar'] as num?)?.toInt() ?? 0,
    );
  }

  factory ReviewSummaryModel.empty() {
    return ReviewSummaryModel(
      averageRating: 0.0,
      totalReviews: 0,
      fiveStar: 0,
      fourStar: 0,
      threeStar: 0,
      twoStar: 0,
      oneStar: 0,
    );
  }
}
