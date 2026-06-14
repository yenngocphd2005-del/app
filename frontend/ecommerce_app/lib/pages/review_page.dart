import 'package:flutter/material.dart';
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
  List<ReviewModel> _reviews = [];
  ReviewSummaryModel _summary = ReviewSummaryModel.empty();
  bool _isLoading = true;
  bool _withPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      ReviewService.getReviews(widget.productId, withPhoto: _withPhoto),
      ReviewService.getRatingSummary(widget.productId),
    ]);

    if (!mounted) return;
    setState(() {
      _reviews = results[0] as List<ReviewModel>;
      _summary = results[1] as ReviewSummaryModel;
      _isLoading = false;
    });
  }

  Future<void> _onWithPhotoChanged(bool value) async {
    setState(() {
      _withPhoto = value;
      _isLoading = true;
    });
    final reviews = await ReviewService.getReviews(
      widget.productId,
      withPhoto: value,
    );
    if (!mounted) return;
    setState(() {
      _reviews = reviews;
      _isLoading = false;
    });
  }

  void _showWriteReview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WriteReviewBottomSheet(
        productId: widget.productId,
        userId: widget.userId,
        onReviewSubmitted: _loadData,
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
                else if (_reviews.isEmpty)
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
                      (context, index) => _buildReviewCard(_reviews[index]),
                      childCount: _reviews.length,
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
              onTap: _showWriteReview,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.primary,
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
                      'Write a review',
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
                  _getInitials(review.userId),
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
                          'User ${review.userId.substring(0, 8)}',
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
                  final imageUrl = _buildImageUrl(review.images[index]);
                  return Padding(
                    padding: EdgeInsets.only(right: index < review.images.length - 1 ? 8 : 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 96,
                          height: 96,
                          color: const Color(0xFFF0F0F0),
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
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

  String _getInitials(String userId) {
    if (userId.length >= 2) {
      return userId.substring(0, 2).toUpperCase();
    }
    return 'U';
  }
}
