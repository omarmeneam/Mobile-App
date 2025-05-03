import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/product_card.dart';
import '../../theme/app_colors.dart';
import '../../viewmodels/search_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final int _currentIndex = 1;
  final TextEditingController _searchController = TextEditingController();

  // Filter state
  String _selectedCategory = 'All Categories';
  String _selectedTimeRange = 'Any Time';
  RangeValues _priceRange = const RangeValues(0, 500);
  bool _sortByPriceAsc = true;

  @override
  void initState() {
    super.initState();
    // Load products when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SearchViewModel>(context, listen: false).loadProducts();
    });
  }

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

  void _applyFilters() {
    final viewModel = Provider.of<SearchViewModel>(context, listen: false);
    
    // Apply category filter
    if (_selectedCategory != 'All Categories') {
      viewModel.filterByCategory(_selectedCategory);
    } else {
      viewModel.resetFilters();
    }
    
    // Apply price sorting
    viewModel.sortByPrice(_sortByPriceAsc);
    
    Navigator.pop(context);
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
                        ].map((timeRange) {
                          return DropdownMenuItem(
                            value: timeRange,
                            child: Text(timeRange),
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
                  Text(
                    'Price Range',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RM ${_priceRange.start.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'RM ${_priceRange.end.toInt()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 1000,
                    divisions: 20,
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
                  
                  // Sort by Price
                  Row(
                    children: [
                      Checkbox(
                        value: _sortByPriceAsc,
                        onChanged: (value) {
                          setState(() {
                            _sortByPriceAsc = value!;
                          });
                        },
                      ),
                      Text(
                        _sortByPriceAsc ? 'Sort by Price (Low to High)' : 'Sort by Price (High to Low)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Apply Filters Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _applyFilters,
                      child: const Text('Apply Filters'),
                    ),
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
    return Consumer<SearchViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
            actions: [
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: _showFilterBottomSheet,
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.searchQuery = '';
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    viewModel.searchQuery = value;
                  },
                ),
              ),
              
              // Results count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Results: ${viewModel.searchResults.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.sort),
                      label: const Text('Sort'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                            title: const Text('Sort By'),
                            children: [
                              SimpleDialogOption(
                                onPressed: () {
                                  viewModel.sortByNewest();
                                  Navigator.pop(context);
                                },
                                child: const Text('Newest First'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  viewModel.sortByPrice(true);
                                  Navigator.pop(context);
                                },
                                child: const Text('Price: Low to High'),
                              ),
                              SimpleDialogOption(
                                onPressed: () {
                                  viewModel.sortByPrice(false);
                                  Navigator.pop(context);
                                },
                                child: const Text('Price: High to Low'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              // Results grid
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : viewModel.error.isNotEmpty
                        ? Center(child: Text(viewModel.error))
                        : viewModel.searchResults.isEmpty
                            ? const Center(child: Text('No results found'))
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 32.0),
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: viewModel.searchResults.length,
                                  itemBuilder: (context, index) {
                                    return ProductCard(
                                      product: viewModel.searchResults[index],
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/product/${viewModel.searchResults[index].id}',
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
              ),
            ],
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
