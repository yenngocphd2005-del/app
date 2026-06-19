import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';
import '../services/api_service.dart';
import '../widgets/write_review_bottom_sheet.dart';

class ReviewPage extends StatefulWidget {
  final String productId;
  final String productName;
  // userId of current logged-in user — fallback to a default UUID if not available
  final String userId;

  const ReviewPage({
    super.key,
    required this.productId,
    required this.productName,
    this.userId = '00000000-0000-0000-0000-000000000099',
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Reviews from API (or locally submitted)
  List<ReviewModel> _userReviews = [];
  // Default reviews from reviews.json — loaded once, never cleared
  List<ReviewModel> _defaultReviews = [];
  ReviewSummaryModel _summary = ReviewSummaryModel.empty();
  bool _isLoading = true;
  bool _withPhoto = false;

  bool get _hasReviewed {
    return _userReviews.any(
      (r) =>
          r.userId == widget.userId &&
          r.productId == widget.productId,
    );
  }

  // Combined display list: user reviews first, then defaults
  // Filtered by _withPhoto if needed
  List<ReviewModel> get _displayReviews {
    final combined = [..._userReviews, ..._defaultReviews];
    if (_withPhoto) {
      return combined.where((r) => r.images.isNotEmpty).toList();
    }
    return combined;
  }

  // Check if a string is a valid UUID format
  bool _isValidUuid(String id) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(id);
  }

  // Load default reviews from assets/reviews.json
  Future<List<ReviewModel>> _loadDefaultReviews({bool withPhoto = false}) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/reviews.json');
      final List<dynamic> data = jsonDecode(jsonStr);
      final reviews = data
          .map((e) => ReviewModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      if (withPhoto) {
        return reviews.where((r) => r.images.isNotEmpty).toList();
      }
      return reviews;
    } catch (_) {
      return [];
    }
  }

  // Compute a summary from a list of reviews
  ReviewSummaryModel _computeSummary(List<ReviewModel> reviews) {
    if (reviews.isEmpty) return ReviewSummaryModel.empty();
    final total = reviews.length;
    int five = 0, four = 0, three = 0, two = 0, one = 0;
    double ratingSum = 0;
    for (final r in reviews) {
      ratingSum += r.rating;
      if (r.rating == 5) {
        five++;
      } else if (r.rating == 4) {
        four++;
      } else if (r.rating == 3) {
        three++;
      } else if (r.rating == 2) {
        two++;
      } else if (r.rating == 1) {
        one++;
      }
    }
    return ReviewSummaryModel(
      averageRating: ratingSum / total,
      totalReviews: total,
      fiveStar: five,
      fourStar: four,
      threeStar: three,
      twoStar: two,
      oneStar: one,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Load defaults once (they never get cleared)
    if (_defaultReviews.isEmpty) {
      _defaultReviews = await _loadDefaultReviews();
    }

    // Load API reviews for valid UUID products
    final isValidId = _isValidUuid(widget.productId);
    List<ReviewModel> apiReviews = [];
    ReviewSummaryModel apiSummary = ReviewSummaryModel.empty();

    if (isValidId) {
      try {
        final results = await Future.wait([
          ReviewService.getReviews(widget.productId),
          ReviewService.getRatingSummary(widget.productId),
        ]);
        apiReviews = results[0] as List<ReviewModel>;
        apiSummary = results[1] as ReviewSummaryModel;
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _userReviews = apiReviews;
      // Use API summary if it has data; else compute from everything
      _summary = apiSummary.totalReviews > 0
          ? apiSummary
          : _computeSummary([...apiReviews, ..._defaultReviews]);
      _isLoading = false;
    });
  }

  // Photo filter: just toggle the flag, _displayReviews getter handles filtering
  void _onWithPhotoChanged(bool value) {
    setState(() {
      _withPhoto = value;
    });
  }

  // Called by WriteReviewBottomSheet with the submitted data.
  // Adds the review locally immediately (optimistic), then tries API in background.
  Future<void> _handleReviewSubmit(
    int rating,
    String comment,
    List<File> images,
  ) async {
    final now = DateTime.now();
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    final dateStr = '${monthNames[now.month - 1]} ${now.day}, ${now.year}';

    // Build local review immediately
    final localReview = ReviewModel(
      id: 'local-${now.millisecondsSinceEpoch}',
      productId: widget.productId,
      userId: widget.userId,
      userName: 'Me',
      rating: rating,
      comment: comment.isNotEmpty ? comment : null,
      createdAt: dateStr,
      images: images.map((f) => f.path).toList(),
    );

    // Prepend to user reviews list and recompute summary
    setState(() {
      _userReviews = [localReview, ..._userReviews];
      _summary = _computeSummary(_displayReviews);
    });

    // Resolve a valid product UUID for the database FK constraint
    String resolvedProductId = widget.productId;

    if (!_isValidUuid(resolvedProductId)) {
      // Mock product — try to get a real product ID from the API
      try {
        final products = await ApiService.getProducts();
        if (products.isNotEmpty) {
          resolvedProductId = products[0]['id']?.toString() ?? resolvedProductId;
        }
      } catch (_) {}
    }

    // Submit to backend for persistence
    try {
      debugPrint('Submitting review — productId: $resolvedProductId, userId: ${widget.userId}');
      final result = await ReviewService.submitReview(
        productId: resolvedProductId,
        userId: widget.userId,
        rating: rating,
        comment: comment,
        images: images.isNotEmpty ? images : null,
      );
      debugPrint('Review submit result: $result');
    } catch (e) {
      debugPrint('Review submit error: $e');
    }
  }

  void _showWriteReview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WriteReviewBottomSheet(
        productId: widget.productId,
        userId: widget.userId,
        onReviewSubmitted: _handleReviewSubmit,
      ),
    );
  }

  // Build the image URL for review photos
  String _buildImageUrl(String path) {
    if (path.startsWith('http')) return path;
    final base = ApiService.baseUrl.replaceAll('/api', '');
    return '$base$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rating and reviews',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadData,
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                // Rating Summary Section
                SliverToBoxAdapter(
                  child: _buildSummarySection(),
                ),

                // Reviews Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_summary.totalReviews} reviews',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // With Photo checkbox
                        Row(
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: Checkbox(
                                value: _withPhoto,
                                onChanged: (v) => _onWithPhotoChanged(v ?? false),
                                activeColor: AppColors.textPrimary,
                                side: BorderSide(
                                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'With photo',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Review List
                if (_isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else if (_displayReviews.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rate_review_outlined,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _withPhoto
                                ? 'No reviews with photos yet'
                                : 'No reviews yet.\nBe the first to review!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildReviewCard(_displayReviews[index]),
                      childCount: _displayReviews.length,
                    ),
                  ),

                // Bottom padding for FAB
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // Write a Review FAB
          Positioned(
            bottom: 24,
            right: 16,
            child: GestureDetector(
              onTap: () {
                if (_hasReviewed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'You have already reviewed this product',
                      ),
                    ),
                  );
                  return;
                }

                _showWriteReview();
              },
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: _hasReviewed
                    ? Colors.grey
                    : AppColors.primary,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit, color: AppColors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _hasReviewed
                          ? 'Write a review'
                          : 'Write a review',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rating&Reviews',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Average rating number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _summary.averageRating.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                      fontSize: 52,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_summary.totalReviews} ratings',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Star bars
              Expanded(
                child: Column(
                  children: [
                    _buildStarBar(5, _summary.fiveStar, _summary.totalReviews),
                    const SizedBox(height: 6),
                    _buildStarBar(4, _summary.fourStar, _summary.totalReviews),
                    const SizedBox(height: 6),
                    _buildStarBar(3, _summary.threeStar, _summary.totalReviews),
                    const SizedBox(height: 6),
                    _buildStarBar(2, _summary.twoStar, _summary.totalReviews),
                    const SizedBox(height: 6),
                    _buildStarBar(1, _summary.oneStar, _summary.totalReviews),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStarBar(int star, int count, int total) {
    final double fraction = total > 0 ? count / total : 0;
    return Row(
      children: [
        Row(
          children: List.generate(star, (i) => const Icon(
            Icons.star,
            color: Color(0xFFFFC120),
            size: 13,
          )),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 4,
              backgroundColor: const Color(0xFFE8E8E8),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 16,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with initials
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  _getInitials(review.userName ?? review.userId),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.userName ?? 'User ${review.userId.length >= 8 ? review.userId.substring(0, 8) : review.userId}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          review.createdAt ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (i) => Icon(
                        i < review.rating ? Icons.star : Icons.star_border,
                        size: 14,
                        color: i < review.rating
                            ? const Color(0xFFFFC120)
                            : const Color(0xFFD3D3D3),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Comment
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment!,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ],

          // Review images
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 96,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  final imgPath = review.images[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < review.images.length - 1 ? 8 : 0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imgPath.startsWith('assets/')
                          ? Image.asset(
                              imgPath,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => _buildBrokenImage(),
                            )
                          : imgPath.startsWith('http')
                              ? Image.network(
                                  imgPath,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => _buildBrokenImage(),
                                )
                              : Image.file(
                                  File(imgPath),
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => _buildBrokenImage(),
                                ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Helpful button
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Helpful',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.thumb_up_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBrokenImage() {
    return Container(
      width: 96,
      height: 96,
      color: const Color(0xFFF0F0F0),
      child: const Icon(
        Icons.broken_image_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }

  String _getInitials(String nameOrId) {
    final trimmed = nameOrId.trim();
    if (trimmed.isEmpty) return 'U';
    // If it looks like a full name (contains space), use first letters of each word
    final parts = trimmed.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    // Otherwise use first 2 chars
    if (trimmed.length >= 2) {
      return trimmed.substring(0, 2).toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }
}
