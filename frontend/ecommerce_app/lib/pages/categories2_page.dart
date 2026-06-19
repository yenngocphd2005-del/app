import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import 'catalog_page.dart';

class Categories2Page extends StatefulWidget {
  final CategoryModel parentCategory;
  final String rootCategoryName;
  final GlobalKey<NavigatorState> shopNavigatorKey;

  const Categories2Page({
    super.key,
    required this.parentCategory,
    required this.rootCategoryName,
    required this.shopNavigatorKey,
  });

  @override
  State<Categories2Page> createState() => _Categories2PageState();
}

class _Categories2PageState extends State<Categories2Page> {
  List<CategoryModel> _subCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSubcategories();
  }

  Future<void> _fetchSubcategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("PARENT CATEGORY ID = ${widget.parentCategory.id}");
      final res = await ApiService.getCategories(parentId: widget.parentCategory.id);
      print("SUB CATEGORY RESULT = $res");
      if (!mounted) return;
      setState(() {
        _subCategories = res.map((json) => CategoryModel.fromJson(json)).toList();
        _applySubCategoryMocksIfEmpty();
        _isLoading = false;
      });
    } catch (e) {
      print("SUB CATEGORY ERROR = $e");
      debugPrint('Error fetching subcategories: $e');
      if (!mounted) return;
      setState(() {
        _subCategories = [];
        _applySubCategoryMocksIfEmpty();
        _isLoading = false;
      });
    }
  }

  void _applySubCategoryMocksIfEmpty() {
    if (_subCategories.isEmpty) {
      final parentId = widget.parentCategory.id;
      _subCategories = [
        CategoryModel(id: 'tops-id', parentId: parentId, categoryName: 'Tops', active: true),
        CategoryModel(id: 'shirts-id', parentId: parentId, categoryName: 'Shirts & Blouses', active: true),
        CategoryModel(id: 'cardigans-id', parentId: parentId, categoryName: 'Cardigans & Sweaters', active: true),
        CategoryModel(id: 'knitwear-id', parentId: parentId, categoryName: 'Knitwear', active: true),
        CategoryModel(id: 'blazers-id', parentId: parentId, categoryName: 'Blazers', active: true),
        CategoryModel(id: 'outerwear-id', parentId: parentId, categoryName: 'Outerwear', active: true),
        CategoryModel(id: 'pants-id', parentId: parentId, categoryName: 'Pants', active: true),
        CategoryModel(id: 'jeans-id', parentId: parentId, categoryName: 'Jeans', active: true),
        CategoryModel(id: 'shorts-id', parentId: parentId, categoryName: 'Shorts', active: true),
        CategoryModel(id: 'skirts-id', parentId: parentId, categoryName: 'Skirts', active: true),
        CategoryModel(id: 'dresses-id', parentId: parentId, categoryName: 'Dresses', active: true),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 20),
          onPressed: () {
            widget.shopNavigatorKey.currentState?.pop();
          },
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
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // View all items button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.shopNavigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (context) => CatalogPage(
                              category: widget.parentCategory,
                              parentCategoryName: widget.rootCategoryName,
                              shopNavigatorKey: widget.shopNavigatorKey,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'VIEW ALL ITEMS',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                // "Choose category" text
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
                  child: Text(
                    'Choose category',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Subcategories ListView
                Expanded(
                  child: ListView.builder(
                    itemCount: _subCategories.length,
                    itemBuilder: (context, index) {
                      final subCat = _subCategories[index];
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFF2F2F2),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            widget.shopNavigatorKey.currentState?.push(
                              MaterialPageRoute(
                                builder: (context) => CatalogPage(
                                  category: subCat,
                                  parentCategoryName: widget.rootCategoryName,
                                  shopNavigatorKey: widget.shopNavigatorKey,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 18.0,
                            ),
                            child: Text(
                              subCat.categoryName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
