import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'categories1_page.dart';


class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  int _homeSubPage = 0;
  final GlobalKey<NavigatorState> _shopNavigatorKey = GlobalKey<NavigatorState>();

  List<dynamic> _newProducts = [];
  List<dynamic> _saleProducts = [];
  bool _isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _refreshProducts() async {
    await _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
    });

    try {
      final newRes = await ApiService.getProductsByTag('NEW');
      final saleRes = await ApiService.getProductsByTag('SALE');

      setState(() {
        _newProducts = newRes;
        _saleProducts = saleRes;
        _isLoadingProducts = false;
      });
    } catch (e) {
      debugPrint('Error fetching products from backend: $e');
      setState(() {
        _isLoadingProducts = false;
      });
    }

    // Apply high-quality local mock fallbacks if database is empty or offline
    if (_newProducts.isEmpty) {
      _newProducts = [
        {
          'id': 'new-1',
          'productName': 'T-Shirt Summer',
          'note': 'Dorothy Perkins',
          'image': 'assets/images/new1.png',
          'salePrice': 15.00,
          'comparePrice': 0.00,
          'tags': [{'tagName': 'NEW'}]
        },
        {
          'id': 'new-2',
          'productName': 'White Blouse',
          'note': 'StreetBrand',
          'image': 'assets/images/new2.png',
          'salePrice': 20.00,
          'comparePrice': 0.00,
          'tags': [{'tagName': 'NEW'}]
        }
      ];
    }

    if (_saleProducts.isEmpty) {
      _saleProducts = [
        {
          'id': 'sale-1',
          'productName': 'Evening Dress',
          'note': 'Dorothy Perkins',
          'image': 'assets/images/sale1.png',
          'salePrice': 12.00,
          'comparePrice': 15.00,
          'tags': [{'tagName': 'SALE'}]
        },
        {
          'id': 'sale-2',
          'productName': 'Sport Dress',
          'note': 'Sitlly',
          'image': 'assets/images/sale2.png',
          'salePrice': 19.00,
          'comparePrice': 22.00,
          'tags': [{'tagName': 'SALE'}]
        },
        {
          'id': 'sale-3',
          'productName': 'Summer Dress',
          'note': 'Dorothy Perkins',
          'image': 'assets/images/sale3.png',
          'salePrice': 12.00,
          'comparePrice': 14.00,
          'tags': [{'tagName': 'SALE'}]
        }
      ];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (_currentIndex == 1) {
          final navigator = _shopNavigatorKey.currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.pop();
            return;
          }
        }
        
        final mainNavigator = Navigator.of(context);
        if (mainNavigator.canPop()) {
          mainNavigator.pop();
        } else {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home_gray.svg', width: 24, height: 24),
            activeIcon: SvgPicture.asset('assets/icons/home_red.svg', width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/shopping_cart_gray.svg', width: 24, height: 24),
            activeIcon: SvgPicture.asset('assets/icons/shopping_cart_red.svg', width: 24, height: 24),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/bag_gray.svg', width: 24, height: 24),
            activeIcon: SvgPicture.asset('assets/icons/bag_red.svg', width: 24, height: 24),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/favourites_gray.svg', width: 24, height: 24),
            activeIcon: SvgPicture.asset('assets/icons/favourites_red.svg', width: 24, height: 24),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/profile_gray.svg', width: 24, height: 24),
            activeIcon: SvgPicture.asset('assets/icons/profile_red.svg', width: 24, height: 24),
            label: 'Profile',
          ),
        ],
      ),
    ),);
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildShopTab();
      case 2:
        return _buildBagTab();
      case 3:
        return _buildFavoritesTab();
      case 4:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // --- HOME TAB (horizontal page view) ---
  Widget _buildHomeTab() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _homeSubPage = index;
        });
      },
      children: [
        _buildHome1Layout(),
        _buildHome2Layout(),
        _buildHome3Layout(),
      ],
    );
  }

  // 1. Home 1: Fashion Sale
  Widget _buildHome1Layout() {
  return RefreshIndicator(
    onRefresh: _refreshProducts,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner 1
          Stack(
            children: [
              Image.asset(
                'assets/images/banner1.png',
                width: double.infinity,
                height: 530,
                fit: BoxFit.cover,
              ),
              // Dark gradient overlay for modern look and high text readability
              Container(
                height: 530,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fashion\nsale',
                      style: GoogleFonts.inter(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Check',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Subpage Indicators (top overlay)
              Positioned(
                top: 50,
                right: 20,
                child: _buildPageDots(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // New Category List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New',
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "You've never seen it before!",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'View all',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _buildHorizontalProductList(_newProducts),
          const SizedBox(height: 48),
        ],
      ),
    ),
    );
  }

  // 2. Home 2: Street Clothes & Sales
  Widget _buildHome2Layout() {
  return RefreshIndicator(
    onRefresh: _refreshProducts,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner 2
          Stack(
            children: [
              Image.asset(
                'assets/images/banner2.png',
                width: double.infinity,
                height: 196,
                fit: BoxFit.cover,
              ),
              Container(
                height: 196,
                width: double.infinity,
                color: Colors.black.withValues(alpha: 0.15),
              ),
              Positioned(
                left: 16,
                bottom: 24,
                child: Text(
                  'Street clothes',
                  style: GoogleFonts.inter(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: _buildPageDots(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Sale Category List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sale',
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Super summer sale",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'View all',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _buildHorizontalProductList(_saleProducts),
          const SizedBox(height: 40),
          // New Category List Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New',
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "You've never seen it before!",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'View all',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _buildHorizontalProductList(_newProducts),
          const SizedBox(height: 48),
        ],
      ),
    ),
    );
  }

  // 3. Home 3: Grid New Collection & Promo Tiles
  Widget _buildHome3Layout() {
  return RefreshIndicator(
    onRefresh: _refreshProducts,
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner 3
          Stack(
            children: [
              Image.asset(
                'assets/images/banner3_newcollection.png',
                width: double.infinity,
                height: 390,
                fit: BoxFit.cover,
              ),
              Container(
                height: 390,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                  ),
                ),
              ),
              Positioned(
                right: 16,
                bottom: 24,
                child: Text(
                  'New collection',
                  style: GoogleFonts.inter(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: _buildPageDots(),
              ),
            ],
          ),
          // Split Promo Grid Layout (matching Figma 3 perfectly)
          Row(
            children: [
              // Left Column
              Expanded(
                child: SizedBox(
                  height: 380,
                  child: Column(
                    children: [
                      // Summer Sale Box
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: AppColors.white,
                          padding: const EdgeInsets.only(left: 16, top: 32),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Summer\nsale',
                              style: GoogleFonts.inter(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Black Box
                      Expanded(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/banner3_black.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              color: Colors.black.withValues(alpha: 0.1),
                            ),
                            Positioned(
                              left: 16,
                              bottom: 24,
                              child: Text(
                                'Black',
                                style: GoogleFonts.inter(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right Column
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/banner3_menshoodie.png',
                      width: double.infinity,
                      height: 380,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 380,
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 48,
                      child: Text(
                        "Men's\nhoodies",
                        style: GoogleFonts.inter(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  // dots page indicators overlaid on top banners
  Widget _buildPageDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final active = _homeSubPage == index;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(left: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active 
                ? AppColors.primary 
                : AppColors.white.withValues(alpha: 0.5),
          ),
        );
      }),
    );
  }

  // list layout builder for horizontal lists
  Widget _buildHorizontalProductList(List<dynamic> products) {
    if (_isLoadingProducts) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return SizedBox(
      height: 310,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }

  // --- SHOP TAB ---
  Widget _buildShopTab() {
    return Navigator(
      key: _shopNavigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => Categories1Page(
            shopNavigatorKey: _shopNavigatorKey,
            onBackToHome: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
        );
      },
    );
  }

  // --- BAG TAB ---
  Widget _buildBagTab() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Bag',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/bag_gray.svg',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Your bag is currently empty.',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our premium collection and start shopping!',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                setState(() {
                  _currentIndex = 0; // return to Home tab
                });
              },
              child: Text(
                'EXPLORE CATALOG',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FAVORITES TAB ---
  Widget _buildFavoritesTab() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Favorites',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ),
      body: _saleProducts.isEmpty 
          ? Center(
              child: Text(
                'No favorite items yet.',
                style: GoogleFonts.inter(color: AppColors.textSecondary),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.52,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _saleProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: _saleProducts[index]);
              },
            ),
    );
  }

  // --- PROFILE TAB (preserving the original Welcome & logout dashboard code) ---
  Widget _buildProfileTab() {
    final user = widget.user;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile settings',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: AppColors.primary),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', '${user.firstName} ${user.lastName}'),
                    _buildInfoRow('Email', user.email),
                    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                      _buildInfoRow('Phone', user.phoneNumber!),
                    _buildInfoRow('Role', user.roleName ?? 'None'),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Fullstack E-Commerce App Project v1.0',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
