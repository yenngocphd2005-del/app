import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../services/api_service.dart';
import '../models/category_model.dart';
import 'review_page.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final CategoryModel category;
  final GlobalKey<NavigatorState> shopNavigatorKey;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.category,
    required this.shopNavigatorKey,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Map<String, dynamic>> _relatedProducts = [];
  bool _isLoadingRelated = true;
  bool _isFavorite = false;
  String _selectedSize = 'Size';
  String _selectedColor = 'Black';
  int _currentImage = 0;

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
  }

  Future<void> _fetchRelatedProducts() async {
    try {
      List<Map<String, dynamic>> related = [];

      // Lấy tất cả sản phẩm
      final products = await ApiService.getProducts();

      for (var item in products) {
        final product = Map<String, dynamic>.from(item);

        // bỏ sản phẩm hiện tại
        if (product['id'].toString() ==
            widget.product['id'].toString()) {
          continue;
        }

        related.add(product);
      }

      // giới hạn 12 sản phẩm
      related.shuffle();

      if (related.length > 12) {
        related = related.sublist(0, 12);
      }

      if (!mounted) return;

      setState(() {
        _relatedProducts = related;
        _isLoadingRelated = false;
      });
    } catch (e) {
      debugPrint("Related product error: $e");

      if (!mounted) return;

      setState(() {
        _isLoadingRelated = false;
      });
    }
  }

  double _getPrice(Map<String, dynamic> product) {
    final price = product['salePrice'];
    if (price is num) return price.toDouble();
    if (price is String) return double.tryParse(price) ?? 0.0;
    return 0.0;
  }

  int _getRating(Map<String, dynamic> product) {
    final rating = product['rating'];
    if (rating is num) return rating.toInt();
    return 4; // Fallback
  }

  int _getReviewCount(Map<String, dynamic> product) {
    final count = product['reviewCount'];
    if (count is num) return count.toInt();
    return 10; // Fallback
  }

  String _getBrand(Map<String, dynamic> product) {
    return product['note'] ?? 'Brand';
  }

  String _getDescription(Map<String, dynamic> product) {
    final desc = product['productDescription'] ?? product['shortDescription'];
    if (desc != null && desc.toString().isNotEmpty) {
      return desc.toString();
    }
    return 'Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.';
  }

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

  void _showSizeSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34),
              topRight: Radius.circular(34),
            ),
          ),
          padding: const EdgeInsets.only(top: 14, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF979797),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select size',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildSizeOption('XS'),
                    _buildSizeOption('S'),
                    _buildSizeOption('M'),
                    _buildSizeOption('L'),
                    _buildSizeOption('XL'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: AppColors.textSecondary, height: 1, thickness: 0.2),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                title: Text(
                  'Size info',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                onTap: () {},
              ),
              const Divider(color: AppColors.textSecondary, height: 1, thickness: 0.2),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $_selectedSize to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'ADD TO CART',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSizeOption(String size) {
    final isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
        Navigator.pop(context);
        _showSizeSelector(); // Re-open to show updated state, or just handle it differently.
        // Actually better to make the BottomSheet stateful, but for simplicity we can just close and update state.
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.product['productName'] ?? '';
    final brand = _getBrand(widget.product);
    final price = _getPrice(widget.product);
    final rating = _getRating(widget.product);
    final reviewCount = _getReviewCount(widget.product);
    final description = _getDescription(widget.product);
    final List<String> productImages = [
      widget.product['image'] ?? '',
      widget.product['image2'] ?? widget.product['image'] ?? '',
    ];
    debugPrint("PRODUCT = ${widget.product}");
    debugPrint("IMAGE1 = ${widget.product['image']}");
    debugPrint("IMAGE2 = ${widget.product['image2']}");

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
          name.isNotEmpty ? name : 'Product Detail',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.textPrimary, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // padding for bottom button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: productImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return _buildProductImage(
                            productImages[index],
                            width: double.infinity,
                            height: 400,
                          );
                        },
                      ),

                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            productImages.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImage == index
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Selectors (Size, Color) & Favorite
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Size Dropdown
                      Expanded(
                        child: GestureDetector(
                          onTap: _showSizeSelector,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedSize,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Color Dropdown (Mocked)
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedColor,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Favorite Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              _isFavorite ? 'assets/icons/heart-red.svg' : 'assets/icons/heart-gray.svg',
                              width: 16,
                              height: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Title and Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              brand,
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: SvgPicture.asset(
                            i < rating ? 'assets/icons/Star-yellow.svg' : 'assets/icons/Star-gray.svg',
                            width: 14,
                            height: 14,
                          ),
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount)',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),

                const Divider(color: AppColors.textSecondary, height: 32, thickness: 0.2),

                // Rating & Reviews tile
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Row(
                    children: [
                      Text(
                        'Rating & Reviews',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...List.generate(5, (i) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: SvgPicture.asset(
                          i < rating ? 'assets/icons/Star-yellow.svg' : 'assets/icons/Star-gray.svg',
                          width: 12,
                          height: 12,
                        ),
                      )),
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount)',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(
                          productId: widget.product['id']?.toString() ?? '',
                          productName: widget.product['productName']?.toString() ?? '',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(color: AppColors.textSecondary, height: 1, thickness: 0.2),

                // Shipping info
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    'Shipping info',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onTap: () {},
                ),
                const Divider(color: AppColors.textSecondary, height: 1, thickness: 0.2),

                // Support
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: Text(
                    'Support',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textPrimary),
                  onTap: () {},
                ),
                const Divider(color: AppColors.textSecondary, height: 1, thickness: 0.2),

                const SizedBox(height: 24),

                // You can also like this
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You can also like this',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_relatedProducts.length} items',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Related Products Horizontal List
                if (_isLoadingRelated)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ))
                else if (_relatedProducts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No related products found.'),
                  )
                else
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _relatedProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildRelatedProductCard(_relatedProducts[index]),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Sticky bottom Add To Cart button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $_selectedSize $_selectedColor to cart!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'ADD TO CART',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProductCard(Map<String, dynamic> product) {
    final name = product['productName'] ?? '';
    final brand = _getBrand(product);
    final price = _getPrice(product);
    final rating = _getRating(product);
    final reviewCount = _getReviewCount(product);
    final imagePath = product['image'] ?? '';

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
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildProductImage(imagePath, width: 140, height: 184),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(5, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: SvgPicture.asset(
                      i < rating ? 'assets/icons/Star-yellow.svg' : 'assets/icons/Star-gray.svg',
                      width: 10,
                      height: 10,
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
            ),
            const SizedBox(height: 4),
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
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '\$${price.toStringAsFixed(0)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
