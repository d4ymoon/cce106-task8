class Product {
  final String name;
  final String price;
  final String status;
  final String image;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.category,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => double.parse(product.price) * quantity;
}

final List<Product> products = [
  Product(
    name: 'Nike Air Max 200',
    price: '180.0',
    status: 'Trending Now',
    image: 'assets/shoes1.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Nike Originals',
    price: '120.0',
    status: 'Out of Stock',
    image: 'assets/shoes2.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Adidas Hoodie Jacket',
    price: '90.0',
    status: 'Trending Now',
    image: 'assets/jacket1.jpg',
    category: 'Jackets',
  ),
  Product(
    name: 'Leather Jacket',
    price: '130.0',
    status: 'Out of Stock',
    image: 'assets/jacket2.jpg',
    category: 'Jackets',
  ),
];