import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import 'categories2_page.dart';

class Categories1Page extends StatefulWidget {
  final GlobalKey<NavigatorState> shopNavigatorKey;
  final VoidCallback? onBackToHome;

  const Categories1Page({
    super.key,
    required this.shopNavigatorKey,
    this.onBackToHome,
  });

  @override
  State<Categories1Page> createState() => _Categories1PageState();
}

class _Categories1PageState extends State<Categories1Page> with TickerProviderStateMixin {
  TabController? _tabController;
  List<CategoryModel> _rootCategories = [];
  List<CategoryModel> _subCategories = [];
  bool _isLoading = true;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final rootRes = await ApiService.getCategories(root: true);
      print("ROOT CATEGORY RESULT = $rootRes");

      if (!mounted) return;

      setState(() {
        _rootCategories = [
          CategoryModel(id: 'women-id', categoryName: 'Women', active: true),
          CategoryModel(id: 'men-id', categoryName: 'Men', active: true),
          CategoryModel(id: 'kids-id', categoryName: 'Kids', active: true),
        ];

        _tabController?.dispose();
        _tabController = TabController(
          length: _rootCategories.length,
          vsync: this,
        );

        _tabController!.addListener(_handleTabSelection);
        _isLoading = false;
      });

      _fetchSubcategories(_rootCategories[0].id);
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      if (!mounted) return;
      setState(() {
        _rootCategories = [
          CategoryModel(id: 'women-id', categoryName: 'Women', active: true),
          CategoryModel(id: 'men-id', categoryName: 'Men', active: true),
          CategoryModel(id: 'kids-id', categoryName: 'Kids', active: true),
        ];
        _tabController?.dispose();
        _tabController = TabController(length: _rootCategories.length, vsync: this);
        _tabController!.addListener(_handleTabSelection);
        _isLoading = false;
      });
      _fetchSubcategories(_rootCategories[0].id);
    }
  }

  void _handleTabSelection() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      setState(() {
        _activeTabIndex = _tabController!.index;
      });
      _fetchSubcategories(_rootCategories[_activeTabIndex].id);
    }
  }

  Future<void> _fetchSubcategories(String parentId) async {
    try {
      final subRes = await ApiService.getCategories(parentId: parentId);
      if (!mounted) return;
      setState(() {
        _subCategories = subRes.map((json) => CategoryModel.fromJson(json)).toList();
        _applySubCategoryMocksIfEmpty(parentId);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _subCategories = [];
        _applySubCategoryMocksIfEmpty(parentId);
      });
    }
  }

  void _applySubCategoryMocksIfEmpty(String parentId) {
    if (_subCategories.isEmpty) {
      _subCategories = [
        CategoryModel(
          id: 'new-id',
          parentId: parentId,
          categoryName: 'New',
          image: 'assets/images/categories_new.png',
          active: true,
        ),
        CategoryModel(
          id: 'clothes-id',
          parentId: parentId,
          categoryName: 'Clothes',
          image: 'assets/images/categories_clothes.png',
          active: true,
        ),
        CategoryModel(
          id: 'shoes-id',
          parentId: parentId,
          categoryName: 'Shoes',
          image: 'assets/images/categories-shoes.png',
          active: true,
        ),
        CategoryModel(
          id: 'accessories-id',
          parentId: parentId,
          categoryName: 'Accessories',
          image: 'assets/images/categories_accesories.png',
          active: true,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  Widget _buildCategoryImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Container(color: Colors.grey[200]);
    }
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.grey[200]);
        },
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(color: Colors.grey[200]);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _tabController == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: widget.onBackToHome,
        ),
        title: Text(
          'Categories',
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.textPrimary,
              unselectedLabelColor: AppColors.textPrimary.withValues(alpha: 0.6),
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16),
              unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 16),
              tabs: _rootCategories.map((cat) => Tab(text: cat.categoryName)).toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'SUMMER SALES',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Up to 50% off',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Categories list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _subCategories.length,
              itemBuilder: (context, index) {
                final subCat = _subCategories[index];
                return GestureDetector(
                  onTap: () {
                    final clothesCat = _subCategories.firstWhere(
                      (cat) => cat.categoryName.toLowerCase() == 'clothes',
                      orElse: () => subCat,
                    );
                    widget.shopNavigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => Categories2Page(
                          parentCategory: clothesCat,
                          rootCategoryName: _rootCategories[_activeTabIndex].categoryName,
                          shopNavigatorKey: widget.shopNavigatorKey,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: Text(
                              subCat.categoryName,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            child: _buildCategoryImage(subCat.image),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
