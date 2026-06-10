import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final String name = product['productName'] ?? 'No Name';
    final String brand = product['note'] ?? 'Brand';
    final String imagePath = product['image'] ?? 'assets/images/placeholder.png';
    
    // Parse prices
    final double salePrice = (product['salePrice'] is num) 
        ? (product['salePrice'] as num).toDouble() 
        : double.tryParse(product['salePrice']?.toString() ?? '0') ?? 0.0;
        
    final double comparePrice = (product['comparePrice'] is num) 
        ? (product['comparePrice'] as num).toDouble() 
        : double.tryParse(product['comparePrice']?.toString() ?? '0') ?? 0.0;

    final bool hasDiscount = comparePrice > salePrice;
    int discountPercent = 0;
    if (hasDiscount && comparePrice > 0) {
      discountPercent = (((comparePrice - salePrice) / comparePrice) * 100).round();
    }

    // Determine badges
    bool isNew = false;
    bool isSale = false;
    final List<dynamic>? tags = product['tags'];
    if (tags != null) {
      for (var t in tags) {
        final String tagName = t['tagName']?.toString().toUpperCase() ?? '';
        if (tagName == 'NEW') isNew = true;
        if (tagName == 'SALE') isSale = true;
      }
    }

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 184,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Badge Top Left
              if (hasDiscount && isSale)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '-$discountPercent%',
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else if (isNew)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'NEW',
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              // Favorite Button Bottom Right
              Positioned(
                bottom: -18,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                  },
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        _isFavorited 
                            ? 'assets/icons/favourites_red.svg' 
                            : 'assets/icons/favourites_gray.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Rating Stars
          Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 14,
                  );
                }),
              ),
              const SizedBox(width: 4),
              Text(
                '(10)',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Brand/Category
          Text(
            brand,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          // Product Name
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Prices
          Row(
            children: [
              if (hasDiscount) ...[
                Text(
                  '${comparePrice.round()}\$',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${salePrice.round()}\$',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ] else ...[
                Text(
                  '${salePrice.round()}\$',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
