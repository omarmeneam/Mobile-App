import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../viewmodels/listing_viewmodel.dart';
import '../../theme/app_colors.dart';

class EditListingScreen extends StatefulWidget {
  final Product product;

  const EditListingScreen({super.key, required this.product});

  @override
  _EditListingScreenState createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late String _category;
  late String _condition;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _descriptionController = TextEditingController(
      text: widget.product.description,
    );
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _category = widget.product.category;
    _condition = widget.product.condition;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateListing() async {
    if (_formKey.currentState!.validate()) {
      print('=== EDIT LISTING START ===');
      print('Updating product: ${widget.product.id}');
      print('Old title: ${widget.product.title}');
      print('New title: ${_titleController.text}');

      final viewModel = Provider.of<ListingViewModel>(context, listen: false);

      final updatedProduct = Product(
        id: widget.product.id,
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        image: widget.product.image,
        images: widget.product.images,
        category: _category,
        condition: _condition,
        createdAt: widget.product.createdAt,
        sellerId: widget.product.sellerId,
        active: widget.product.active,
        views: widget.product.views,
      );

      print('Created updated product object:');
      print('ID: ${updatedProduct.id}');
      print('Title: ${updatedProduct.title}');
      print('Price: ${updatedProduct.price}');
      print('Category: ${updatedProduct.category}');

      final success = await viewModel.updateListing(updatedProduct);
      print('Update result: $success');

      if (success && mounted) {
        print('Update successful, showing snackbar and popping');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing updated successfully')),
        );
        Navigator.pop(context);
      } else {
        print('Update failed');
      }
      print('=== EDIT LISTING END ===');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  border: OutlineInputBorder(),
                  prefixText: 'RM ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items:
                    [
                      'Electronics',
                      'Fashion',
                      'Home & Living',
                      'Sports',
                      'Books',
                      'Others',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _category = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Condition
              DropdownButtonFormField<String>(
                value: _condition,
                decoration: const InputDecoration(
                  labelText: 'Condition',
                  border: OutlineInputBorder(),
                ),
                items:
                    ['New', 'Like New', 'Good', 'Fair', 'Poor'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _condition = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Update Button
              ElevatedButton(
                onPressed: _updateListing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Update Listing',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
