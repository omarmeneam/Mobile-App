import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../models/product.dart';
import '../../theme/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter state
  String _selectedCategory = 'All Categories';
  String _selectedTimeRange = 'Any Time';
  RangeValues _priceRange = const RangeValues(0, 500);

  // Mock product data
  final List<Product> _products = [
    Product(
      id: 1,
      title: 'Textbook - Introduction to Psychology',
      price: 45.0,
      image: 'assets/images/placeholder.png',
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Product(
      id: 2,
      title: 'Desk Lamp - Adjustable LED',
      price: 25.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Product(
      id: 3,
      title: 'Dorm Mini Fridge',
      price: 80.0,
      image: 'assets/images/placeholder.png',
      category: 'Appliances',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Product(
      id: 4,
      title: 'Scientific Calculator',
      price: 30.0,
      image: 'assets/images/placeholder.png',
      category: 'Electronics',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  DateTime? _getDateFromTimeRange(String range) {
    final now = DateTime.now();
    switch (range) {
      case 'Last 24 hours':
        return now.subtract(const Duration(days: 1));
      case 'Last 3 days':
        return now.subtract(const Duration(days: 3));
      case 'Last week':
        return now.subtract(const Duration(days: 7));
      case 'Last month':
        return now.subtract(const Duration(days: 30));
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNavBarTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Already on search
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

  List<Product> get _filteredProducts {
    return _products.where((product) {
      // Filter by search query
      final matchesQuery =
          _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());

      // Filter by category
      final matchesCategory =
          _selectedCategory == 'All Categories' ||
          product.category == _selectedCategory;

      // Filter by time range
      final DateTime? timeFilter = _getDateFromTimeRange(_selectedTimeRange);
      final matchesTimeRange =
          timeFilter == null || product.createdAt.isAfter(timeFilter);

      // Filter by price
      final matchesPrice =
          product.price >= _priceRange.start &&
          product.price <= _priceRange.end;

      return matchesQuery &&
          matchesCategory &&
          matchesTimeRange &&
          matchesPrice;
    }).toList();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Results',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Category Filter
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items:
                        [
                          'All Categories',
                          'Books',
                          'Electronics',
                          'Furniture',
                          'Clothing',
                          'Appliances',
                        ].map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Time Range Filter
                  Text(
                    'Posted Time',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedTimeRange,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items:
                        [
                          'Any Time',
                          'Last 24 hours',
                          'Last 3 days',
                          'Last week',
                          'Last month',
                        ].map((range) {
                          return DropdownMenuItem(
                            value: range,
                            child: Text(range),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTimeRange = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Price Range Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price Range',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'RM ${_priceRange.start.toInt()} - RM ${_priceRange.end.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 500,
                    divisions: 50,
                    activeColor: AppColors.primary,
                    labels: RangeLabels(
                      'RM ${_priceRange.start.toInt()}',
                      'RM ${_priceRange.end.toInt()}',
                    ),
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),

                  const Spacer(),

                  // Apply Filters Button
                  ElevatedButton(
                    onPressed: () {
                      this.setState(() {
                        // Update the main state with filter values
                        _selectedCategory = _selectedCategory;
                        _selectedTimeRange = _selectedTimeRange;
                        _priceRange = _priceRange;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for items...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon:
                          _searchQuery.isNotEmpty
                              ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                              : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterBottomSheet,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),

          // Search Results
          if (_searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${_filteredProducts.length} results for "$_searchQuery"',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

          // Product Grid
          Expanded(
            child:
                _filteredProducts.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? 'Search for items'
                                : 'No results found for "$_searchQuery"',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Try a different search term',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.70,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: _filteredProducts[index],
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product/${_filteredProducts[index].id}',
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
