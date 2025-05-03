import '../models/product.dart';

class ProductService {
  // Simulate API call to fetch products
  Future<List<Product>> getProducts() async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return dummy data for now
    return [
      Product(
        id: 1,
        title: 'MacBook Pro 16" M1 Pro 512GB',
        price: 1899.99,
        description: 'Slightly used MacBook Pro 16" with M1 Pro chip, 16GB RAM, 512GB SSD. In excellent condition.',
        image: 'https://images.pexels.com/photos/303383/pexels-photo-303383.jpeg',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        seller: Seller(
          id: 1,
          name: 'Alex Johnson',
          avatar: 'https://i.pravatar.cc/150?img=32',
          rating: 4.8,
          joinedDate: 'Jan 2023',
          online: true,
        ),
        views: 42,
      ),
      Product(
        id: 2,
        title: 'Calculus: Early Transcendentals 8th Edition',
        price: 45.00,
        description: 'Calculus: Early Transcendentals 8th Edition. Minor highlighting in first 3 chapters.',
        image: 'https://images.pexels.com/photos/5834/nature-grass-leaf-green.jpg',
        category: 'Books',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        seller: Seller(
          id: 2,
          name: 'Maria Garcia',
          avatar: 'https://i.pravatar.cc/150?img=48',
          rating: 4.6,
          joinedDate: 'Sep 2022',
        ),
        views: 28,
      ),
      Product(
        id: 3,
        title: 'Ergonomic Mesh Office Chair',
        price: 129.99,
        description: 'Comfortable ergonomic desk chair, perfect for long study sessions. Black mesh back, height adjustable.',
        image: 'https://images.pexels.com/photos/1957478/pexels-photo-1957478.jpeg',
        category: 'Furniture',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        seller: Seller(
          id: 4,
          name: 'Sarah Kim',
          avatar: 'https://i.pravatar.cc/150?img=44',
          rating: 4.7,
          joinedDate: 'Nov 2022',
        ),
        views: 35,
      ),
      Product(
        id: 4,
        title: 'iPhone 13 Pro 128GB Sierra Blue',
        price: 699.99,
        description: 'iPhone 13 Pro 128GB, Sierra Blue. Minor wear on the corners but perfect working condition. Includes charger.',
        image: 'https://images.pexels.com/photos/47261/pexels-photo-47261.jpeg',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        seller: Seller(
          id: 5,
          name: 'Michael Lee',
          avatar: 'https://i.pravatar.cc/150?img=67',
          rating: 4.9,
          joinedDate: 'Oct 2022',
          online: true,
        ),
        views: 64,
      ),
      Product(
        id: 5,
        title: 'Sony WH-1000XM4 Wireless Headphones',
        price: 249.99,
        description: 'Sony WH-1000XM4 noise cancelling headphones in black. Purchased 6 months ago, like new condition.',
        image: 'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        seller: Seller(
          id: 3,
          name: 'Daniel Chen',
          avatar: 'https://i.pravatar.cc/150?img=33',
          rating: 4.5,
          joinedDate: 'Aug 2022',
        ),
        views: 54,
      ),
      Product(
        id: 6,
        title: 'Physics for Scientists and Engineers',
        price: 50.00,
        description: 'Physics for Scientists and Engineers 10th Edition by Serway and Jewett. Good condition, no highlighting.',
        image: 'https://images.unsplash.com/photo-1595501267540-7c3a1733494e?q=80&w=800',
        category: 'Books',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        seller: Seller(
          id: 6,
          name: 'Olivia Wilson',
          avatar: 'https://randomuser.me/api/portraits/women/26.jpg',
          rating: 4.3,
          joinedDate: 'Dec 2022',
          online: true,
        ),
        views: 19,
      ),
      Product(
        id: 7,
        title: 'Modern Desk Lamp with Wireless Charging',
        price: 45.99,
        description: 'LED desk lamp with built-in wireless charger, perfect for dorm rooms. Adjustable brightness and color temperature.',
        image: 'https://images.unsplash.com/photo-1560865542-9fd0072e7234?q=80&w=800',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        seller: Seller(
          id: 7,
          name: 'Ethan Brown',
          avatar: 'https://randomuser.me/api/portraits/men/81.jpg',
          rating: 4.2,
          joinedDate: 'Feb 2023',
        ),
        views: 31,
      ),
      Product(
        id: 8,
        title: 'HP Color Laser Printer',
        price: 159.99,
        description: 'HP Color LaserJet Pro MFP. Works perfectly, just upgraded to a larger model. Includes extra toner cartridges.',
        image: 'https://images.unsplash.com/photo-1612815154858-60aa4c59eaa6?q=80&w=800',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        seller: Seller(
          id: 8,
          name: 'Jessica Taylor',
          avatar: 'https://randomuser.me/api/portraits/women/12.jpg',
          rating: 4.7,
          joinedDate: 'July 2022',
          online: true,
        ),
        views: 22,
      ),
      Product(
        id: 9,
        title: 'Minimalist Bedside Table',
        price: 79.99,
        description: 'Modern minimalist bedside table with drawer. White finish with bamboo accents. Perfect condition.',
        image: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2?q=80&w=800',
        category: 'Furniture',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        seller: Seller(
          id: 9,
          name: 'Andrew Rodriguez',
          avatar: 'https://randomuser.me/api/portraits/men/67.jpg',
          rating: 4.4,
          joinedDate: 'Sep 2022',
        ),
        views: 41,
      ),
      Product(
        id: 10,
        title: 'Electric Skateboard - Boosted Mini X',
        price: 450.00,
        description: 'Boosted Mini X electric skateboard, great for campus commuting. Battery recently replaced, excellent condition.',
        image: 'https://images.unsplash.com/photo-1550226891-ef816aed4a98?q=80&w=800',
        category: 'Transportation',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        seller: Seller(
          id: 10,
          name: 'Kevin Patel',
          avatar: 'https://randomuser.me/api/portraits/men/54.jpg',
          rating: 4.8,
          joinedDate: 'Oct 2022',
          online: true,
        ),
        views: 75,
      ),
    ];
  }
  
  Future<Product> getProductById(int id) async {
    // This would be an API call in a real app
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get the list of products
    final products = await getProducts();
    
    // Try to find the product by ID
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      // If not found, return a default product
      return Product(
        id: id,
        title: 'MacBook Pro 16" M1 Pro 512GB',
        price: 1899.99,
        description: 'Slightly used MacBook Pro 16" with M1 Pro chip, 16GB RAM, 512GB SSD. In excellent condition.',
        image: 'https://images.pexels.com/photos/303383/pexels-photo-303383.jpeg',
        category: 'Electronics',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        seller: Seller(
          id: 1,
          name: 'Alex Johnson',
          avatar: 'https://i.pravatar.cc/150?img=32',
          rating: 4.8,
          joinedDate: 'Jan 2023',
          online: true,
        ),
        views: 42,
      );
    }
  }
  
  Future<bool> createProduct(Product product) async {
    // Simulate API call to create a product
    await Future.delayed(const Duration(milliseconds: 1000));
    return true;
  }
  
  Future<bool> updateProduct(Product product) async {
    // Simulate API call to update a product
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
  
  Future<bool> deleteProduct(int id) async {
    // Simulate API call to delete a product
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
