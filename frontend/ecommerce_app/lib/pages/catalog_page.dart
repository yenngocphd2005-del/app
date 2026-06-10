import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import 'product_detail_page.dart';

class CatalogPage extends StatefulWidget {
  final CategoryModel category;
  final String parentCategoryName;
  final GlobalKey<NavigatorState> shopNavigatorKey;

  const CatalogPage({
    super.key,
    required this.category,
    required this.parentCategoryName,
    required this.shopNavigatorKey,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  bool _isGridView = false;
  bool _sortAscending = true;
  final Set<int> _favorites = {};

  final List<String> _filterTags = [
    'T-shirts',
    'Crop tops',
    'Sleeveless',
    'Blouses',
    'Shirts',
  ];
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
  setState(() => _isLoading = true);

    try {
      print('CATEGORY ID = ${widget.category.id}');

      final res = await ApiService.getProductsByCategoryId(widget.category.id);

      print('API RESULT COUNT = ${res.length}');
      print('API RESULT = $res');

      if (!mounted) return;

      setState(() {
        _products = res.map((item) => Map<String, dynamic>.from(item)).toList();

        if (_products.isEmpty) {
          print('USING MOCK PRODUCTS');
          _applyMockProducts();
        }

        _isLoading = false;
      });
    } catch (e) {
      print('API ERROR = $e');

      if (!mounted) return;

      setState(() {
        _applyMockProducts();
        _isLoading = false;
      });
    }
  }

  void _applyMockProducts() {
    final catName = widget.category.categoryName.toLowerCase();
    String prefix = 'tops';
    if (catName.contains('shirt') || catName.contains('blouse')) {
      prefix = 'Shirts&Blouses';
    } else if (catName.contains('sweat') || catName.contains('cardigan')) {
      prefix = 'Cardigans&Sweaters';
    } else if (catName.contains('knit')) {
      prefix = 'Knitwear';
    } else if (catName.contains('blazer')) {
      prefix = 'Blazers';
    } else if (catName.contains('outer')) {
      prefix = 'Outerwear';
    } else if (catName.contains('pant')) {
      prefix = 'Pants';
    } else if (catName.contains('jean')) {
      prefix = 'Jeans';
    } else if (catName.contains('short')) {
      prefix = 'Shorts';
    } else if (catName.contains('skirt')) {
      prefix = 'Skirts';
    } else if (catName.contains('dress')) {
      prefix = 'Dresses';
    } else if (catName.contains('sneaker')) {
      prefix = 'tops';
    } else if (catName.contains('sandal')) {
      prefix = 'Shirts&Blouses';
    } else if (catName.contains('heel')) {
      prefix = 'Cardigans&Sweaters';
    } else if (catName.contains('boot')) {
      prefix = 'Outerwear';
    } else if (catName.contains('bag')) {
      prefix = 'Jeans';
    } else if (catName.contains('sunglass')) {
      prefix = 'Knitwear';
    } else if (catName.contains('hat')) {
      prefix = 'Blazers';
    } else if (catName.contains('new arrival')) {
      prefix = 'new';
    } else if (catName.contains('best seller')) {
      prefix = 'sale';
    }

    _products = List.generate(10, (i) {
      final idx = i + 1;
      String img = '';
      if (prefix == 'new') {
        img = 'assets/images/new${idx > 7 ? (idx - 7) : idx}.png';
      } else if (prefix == 'sale') {
        img = 'assets/images/sale$idx.png';
      } else {
        img = 'assets/images/$prefix$idx.1.png';
      }

      return {
        'id': '${widget.category.id}-$idx',
        'productName': '${widget.category.categoryName} $idx',
        'note': 'Mango',
        'salePrice': 10.0 + (idx * 5),
        'comparePrice': prefix == 'sale' ? (15.0 + (idx * 6)) : 0.0,
        'image': img,
        'image2': img.replaceAll('.1.png', '.2.png'),
        'rating': 4,
        'reviewCount': 5,
      };
    });
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
      _products.sort((a, b) {
        final priceA = (a['salePrice'] is num) ? (a['salePrice'] as num).toDouble() : 0.0;
        final priceB = (b['salePrice'] is num) ? (b['salePrice'] as num).toDouble() : 0.0;
        return _sortAscending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
      });
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  double _getPrice(Map<String, dynamic> product) {
    final price = product['salePrice'];
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0.0;
    return 0.0;
  }

  double _getComparePrice(Map<String, dynamic> product) {
    final price = product['comparePrice'];
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0.0;
    return 0.0;
  }

  int _getRating(Map<String, dynamic> product) {
    final rating = product['rating'];
    if (rating is num) return rating.toInt();
    return 0;
  }

  int _getReviewCount(Map<String, dynamic> product) {
    final count = product['reviewCount'];
    if (count is num) return count.toInt();
    return 0;
  }

  String _getBrand(Map<String, dynamic> product) {
    return product['note'] ?? '';
  }

  int _getDiscountPercent(Map<String, dynamic> product) {
    final salePrice = _getPrice(product);
    final comparePrice = _getComparePrice(product);
    if (comparePrice > 0 && comparePrice > salePrice) {
      return (((comparePrice - salePrice) / comparePrice) * 100).round();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final title = "${widget.parentCategoryName}'s ${widget.category.categoryName.toLowerCase()}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () {
            widget.shopNavigatorKey.currentState?.pop();
          },
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
              width: 18,
              height: 18,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                // Filter tags horizontal scroll
                _buildFilterTags(),
                // Control bar: Filters | Sort | View toggle
                _buildControlBar(),
                // Products list or grid
                Expanded(
                  child: _isGridView ? _buildGridView() : _buildListView(),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterTags() {
    return Container(
      color: AppColors.white,
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _filterTags.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedFilterIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _filterTags[index],
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Filters button
          GestureDetector(
            onTap: () {
              // Filters action placeholder
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/filters.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
                Text(
                  'Filters',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 65),
          // Sort button
          GestureDetector(
            onTap: _toggleSort,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/price.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                ),
                const SizedBox(width: 6),
                Text(
                  _sortAscending ? 'Price: lowest to high' : 'Price: highest to low',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // View toggle button
          GestureDetector(
            onTap: _toggleView,
            child: SvgPicture.asset(
              'assets/icons/view_module.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                _isGridView ? AppColors.primary : AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== LIST VIEW (catalog1) =====================
  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return _buildListItem(index);
      },
    );
  }

  Widget _buildListItem(int index) {
    final product = _products[index];
    final name = product['productName'] ?? '';
    final brand = _getBrand(product);
    final price = _getPrice(product);
    final comparePrice = _getComparePrice(product);
    final rating = _getRating(product);
    final reviewCount = _getReviewCount(product);
    final imagePath = product['image'] ?? '';
    final isFavorite = _favorites.contains(index);

    return GestureDetector(
      onTap: () {
        widget.shopNavigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              category: widget.category,
              shopNavigatorKey: widget.shopNavigatorKey,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: _buildProductImage(imagePath, width: 104, height: 104),
                  ),
                  // Product info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product name
                          Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          // Brand
                          Text(
                            brand,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Rating stars + review count
                          _buildRatingRow(rating, reviewCount),
                          const SizedBox(height: 6),
                          // Price
                          _buildPriceRow(price, comparePrice),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Favorite heart button in bottom-right corner, overlapping bottom-right edge
            Positioned(
              bottom: -10,
              right: 0,
              child: _buildFavoriteButton(index, isFavorite, size: 36, elevated: true),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== GRID VIEW (catalog2) =====================
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
        childAspectRatio: 0.6,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return _buildGridItem(index);
      },
    );
  }

  Widget _buildGridItem(int index) {
    final product = _products[index];
    final name = product['productName'] ?? '';
    final brand = _getBrand(product);
    final price = _getPrice(product);
    final comparePrice = _getComparePrice(product);
    final rating = _getRating(product);
    final reviewCount = _getReviewCount(product);
    final imagePath = product['image'] ?? '';
    final isFavorite = _favorites.contains(index);
    final discountPercent = _getDiscountPercent(product);

    return GestureDetector(
      onTap: () {
        widget.shopNavigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: product,
              category: widget.category,
              shopNavigatorKey: widget.shopNavigatorKey,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with optional discount badge and favorite button
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildProductImage(imagePath, width: double.infinity, height: 184),
              ),
              // Discount badge (top-left)
              if (discountPercent > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '-$discountPercent%',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              // Favorite heart (bottom-right, overlapping image)
              Positioned(
                bottom: -16,
                right: 0,
                child: _buildFavoriteButton(index, isFavorite, size: 36, elevated: true),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Rating stars + review count
          _buildRatingRow(rating, reviewCount),
          const SizedBox(height: 4),
          // Brand
          Text(
            brand,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Product name
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Price with optional compare price
          _buildPriceRow(price, comparePrice),
        ],
      ),
    );
  }

  // ===================== SHARED WIDGETS =====================

  Widget _buildProductImage(String imagePath, {required double width, required double height}) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildImagePlaceholder(width, height),
      );
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildImagePlaceholder(width, height),
      );
    }
    return _buildImagePlaceholder(width, height);
  }

  Widget _buildImagePlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF0F0F0),
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 40),
      ),
    );
  }

  Widget _buildRatingRow(int rating, int reviewCount) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: 1),
            child: SvgPicture.asset(
              i < rating ? 'assets/icons/Star-yellow.svg' : 'assets/icons/Star-gray.svg',
              width: 13,
              height: 12,
            ),
          );
        }),
        const SizedBox(width: 2),
        Text(
          '($reviewCount)',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(double price, double comparePrice) {
    final hasDiscount = comparePrice > 0 && comparePrice > price;

    return Row(
      children: [
        if (hasDiscount) ...[
          Text(
            '${comparePrice.toStringAsFixed(0)}\$',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          '${price.toStringAsFixed(0)}\$',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: hasDiscount ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(int index, bool isFavorite, {double size = 36, bool elevated = false}) {
    return GestureDetector(
      onTap: () => _toggleFavorite(index),
      child: Container(
        width: size,
        height: size,
        decoration: elevated
            ? BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              )
            : null,
        child: Center(
          child: SvgPicture.asset(
            isFavorite ? 'assets/icons/heart-red.svg' : 'assets/icons/heart-gray.svg',
            width: 16,
            height: 14,
          ),
        ),
      ),
    );
  }
}
