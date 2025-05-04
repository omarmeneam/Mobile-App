import 'package:flutter/material.dart';
import '../models/product.dart';

class AdminProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final Function() onApprove;
  final Function() onTakeDown;
  final Function() onBanUser;
  final bool isPending;

  const AdminProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onApprove,
    required this.onTakeDown,
    required this.onBanUser,
    this.isPending = true,
  });

  void _showModerateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Moderate Listing'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text('Approve Post'),
                  onTap: () {
                    Navigator.pop(context);
                    onApprove();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.warning, color: Colors.orange),
                  title: const Text('Take Down & Warn'),
                  onTap: () {
                    Navigator.pop(context);
                    onTakeDown();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text('Ban User'),
                  onTap: () {
                    Navigator.pop(context);
                    onBanUser();
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate appropriate height based on available width
          final cardWidth = constraints.maxWidth;
          final imageHeight = cardWidth * 0.85; // Image takes 85% of width for aspect ratio
          
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isPending ? Colors.orange.withOpacity(0.5) : Colors.grey.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image section with fixed height
                SizedBox(
                  height: imageHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                        child: product.image.startsWith('http')
                          ? Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://placehold.co/600x400/png?text=No+Image',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://placehold.co/600x400/png?text=No+Image',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                      ),
                      if (isPending)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Pending Review',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          children: [
                            // Quick action buttons
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green.withOpacity(0.9),
                              child: IconButton(
                                icon: const Icon(Icons.check, size: 16, color: Colors.white),
                                onPressed: onApprove,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            const SizedBox(width: 4),
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.red.withOpacity(0.9),
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                                onPressed: onTakeDown,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Product Details with fixed heights
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title with fixed height
                      SizedBox(
                        height: 42, // Fixed height for 2 lines of text
                        child: Text(
                          product.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Seller info with fixed height
                      SizedBox(
                        height: 24,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundImage: (product.seller?.avatar != null && product.seller!.avatar.startsWith('http'))
                                ? NetworkImage(product.seller!.avatar) as ImageProvider
                                : AssetImage(product.seller?.avatar ?? 'assets/images/placeholder.png'),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                product.seller?.name ?? 'Unknown',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Price and button row with fixed height
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Price and Timestamp
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'RM ${product.price.toStringAsFixed(2)}',
                                      style: Theme.of(context).textTheme.titleMedium
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    product.timeAgo,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            // Moderate Button
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                icon: const Icon(Icons.more_vert, size: 20),
                                onPressed: () => _showModerateDialog(context),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
