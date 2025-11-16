import 'package:flutter/material.dart';
import 'package:flutter_application_6/models/product_model.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;
  Set<Product> favoriteProducts = {};
  List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damondamon E-Commerce App'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: currentNavIndex == 0 ? _buildHome() : currentNavIndex == 1 ? _buildFavorites() : _buildCart(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'Cart'),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Our Products", style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _categoryButton('All Products', 0),
              _categoryButton('Jackets', 1),
              _categoryButton('Sneakers', 2),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _buildProductGrid() {
    List<Product> displayedProducts;

    if (selectedIndex == 0) {
      displayedProducts = products;
    } else if (selectedIndex == 1) {
      displayedProducts = products.where((product) => product.category == 'Jackets').toList();
    } else {
      displayedProducts = products.where((product) => product.category == 'Sneakers').toList();
    }

    return GridView.builder(
      itemCount: displayedProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = displayedProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _categoryButton(String title, int index) {
    return ElevatedButton(
      onPressed: () => setState(() => selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIndex == index ? Colors.red : Colors.grey[200],
        foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title),
    );
  }

  Widget _buildFavorites() {
    if (favoriteProducts.isEmpty) {
      return const Center(
        child: Text('No favorite products yet.'),
      );
    }

    return GridView.builder(
      itemCount: favoriteProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = favoriteProducts.elementAt(index);
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildCart() {
    if (cartItems.isEmpty) {
      return const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final totalAmount = cartItems.fold(
        0.0, (sum, item) => sum + item.totalPrice);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return _buildCartItem(cartItem);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _checkout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'CHECKOUT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(cartItem.product.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${cartItem.product.price}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: () => _updateQuantity(cartItem, -1),
                ),
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => _updateQuantity(cartItem, 1),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeFromCart(cartItem),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final isFavorite = favoriteProducts.contains(product);
    final isInCart = cartItems.any((item) => item.product == product);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: isInCart ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    if (isInCart) {
                      _removeFromCartByProduct(product);
                    } else {
                      _addToCart(product);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isFavorite) {
                        favoriteProducts.remove(product);
                      } else {
                        favoriteProducts.add(product);
                      }
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product.status,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${product.price}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      final existingItemIndex =
          cartItems.indexWhere((item) => item.product == product);
      if (existingItemIndex != -1) {
        cartItems[existingItemIndex].quantity++;
      } else {
        cartItems.add(CartItem(product: product));
      }
    });
  }

  void _removeFromCart(CartItem cartItem) {
    setState(() {
      cartItems.remove(cartItem);
    });
  }

  void _removeFromCartByProduct(Product product) {
    setState(() {
      cartItems.removeWhere((item) => item.product == product);
    });
  }

  void _updateQuantity(CartItem cartItem, int change) {
    setState(() {
      final newQuantity = cartItem.quantity + change;
      if (newQuantity > 0) {
        cartItem.quantity = newQuantity;
      } else {
        cartItems.remove(cartItem);
      }
    });
  }

  void _checkout() {
    if (cartItems.isEmpty) return;

    final totalAmount = cartItems.fold(
        0.0, (sum, item) => sum + item.totalPrice);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}