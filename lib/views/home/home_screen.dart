import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../viewmodels/home_viewmodel.dart';

IconData _getFallbackIcon(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'all':
      return Icons.apps;
    case 'books':
      return Icons.book;
    case 'electronics':
      return Icons.devices;
    case 'furniture':
      return Icons.chair;
    case 'clothing':
      return Icons.shopping_bag;
    case 'appliances':
      return Icons.kitchen;
    case 'transportation':
      return Icons.directions_car;
    default:
      return Icons.category;
  }
}

class CategoryItem {
  final String name;
  final String imageUrl;
  final Color gradientStart;
  final Color gradientEnd;

  const CategoryItem({
    required this.name,
    required this.imageUrl,
    required this.gradientStart,
    required this.gradientEnd,
  });
}

final List<CategoryItem> categories = [
  CategoryItem(
    name: 'All',
    imageUrl: 'https://img.icons8.com/color/96/grid-2.png',
    gradientStart: const Color(0xFF6A11CB),
    gradientEnd: const Color(0xFF2575FC),
  ),
  CategoryItem(
    name: 'Books',
    imageUrl: 'https://img.icons8.com/plasticine/100/books.png',
    gradientStart: const Color(0xFF1E3C72),
    gradientEnd: const Color(0xFF2A5298),
  ),
  CategoryItem(
    name: 'Electronics',
    imageUrl: 'https://img.icons8.com/plasticine/100/apple-watch.png',
    gradientStart: const Color(0xFF4776E6),
    gradientEnd: const Color(0xFF8E54E9),
  ),
  CategoryItem(
    name: 'Furniture',
    imageUrl: 'https://img.icons8.com/plasticine/100/armchair.png',
    gradientStart: const Color(0xFFF6D365),
    gradientEnd: const Color(0xFFFDA085),
  ),
  CategoryItem(
    name: 'Clothing',
    imageUrl: 'https://img.icons8.com/plasticine/100/mens-hoodie--v2.png',
    gradientStart: const Color(0xFF00CDAC),
    gradientEnd: const Color(0xFF8DDAD5),
  ),
  CategoryItem(
    name: 'Appliances',
    imageUrl: 'https://img.icons8.com/plasticine/200/microwave.png',
    gradientStart: const Color(0xFFFF4E50),
    gradientEnd: const Color(0xFFF9D423),
  ),
  CategoryItem(
    name: 'Transportation',
    imageUrl: 'https://img.icons8.com/plasticine/100/fiat-500--v1.png',
    gradientStart: const Color(0xFF4568DC),
    gradientEnd: const Color(0xFFB06AB3),
  ),
];

class CategoryCard extends StatefulWidget {
  final CategoryItem category;
  final Function(String) onCategorySelected;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onCategorySelected,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: -0.05,
      end: 0.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive sizes based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = screenWidth * 0.22; // 22% of screen width
    final iconSize = cardSize * 0.8; // 80% of card size
    final verticalPadding = cardSize * 0.4; // 40% of card size for top padding

    return GestureDetector(
      onTap: () => widget.onCategorySelected(widget.category.name),
      child: Column(
        children: [
          SizedBox(height: verticalPadding),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(cardSize * 0.2),
                  boxShadow: [
                    BoxShadow(
                      color: widget.category.gradientStart.withAlpha(51),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                      spreadRadius: 1,
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.category.gradientStart,
                      widget.category.gradientEnd,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -verticalPadding,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(-0.1)
                            ..rotateZ(_rotationAnimation.value),
                      child: Image.network(
                        widget.category.imageUrl,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getFallbackIcon(widget.category.name),
                            size: iconSize * 0.75,
                            color: Colors.white,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.category.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoriesSection({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Browse Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children:
                categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: CategoryCard(
                      category: category,
                      onCategorySelected: onCategorySelected,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Fetch products when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).loadProducts();
    });
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search');
        break;
      case 2:
        Navigator.pushNamed(context, '/create-listing');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        // Get filtered products based on selected category
        final filteredProducts =
            _selectedCategory == 'All'
                ? viewModel.products
                : viewModel.getProductsByCategory(_selectedCategory);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'assets/images/LogoImage.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 8),
                Image.asset('assets/images/LogoText.png', height: 26),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.message_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/messages');
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
            ],
          ),
          body:
              viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.error.isNotEmpty
                  ? Center(child: Text(viewModel.error))
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/search');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Search for items...',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        CategoriesSection(
                          onCategorySelected: _onCategorySelected,
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            16.0,
                            16.0,
                            8.0,
                          ),
                          child:
                              filteredProducts.isEmpty
                                  ? Center(
                                    child: Text(
                                      'No products in this category',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  )
                                  : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.65,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                        ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      return ProductCard(
                                        product: filteredProducts[index],
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            '/product/${filteredProducts[index].id}',
                                          );
                                        },
                                      );
                                    },
                                  ),
                        ),
                        // Extra space at the bottom for safe area
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavBarTap,
          ),
        );
      },
    );
  }
}
