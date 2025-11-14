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
        child: currentNavIndex == 0 ? _buildHome() : _buildFavorites(),
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
        ],
      ),
    );
  }


  Widget _buildHome(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Our Products", style: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.bold
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
  Widget _buildProductGrid(){
    List<Product> displayedProducts;

    if (selectedIndex == 0){
      displayedProducts = products;
    } else if (selectedIndex == 1){
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

  Widget _categoryButton(String title, int index){
    return ElevatedButton(
      onPressed: () => setState(() =>selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIndex == index ? Colors.red : Colors.grey[200],
        foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title),
      );
  }

  Widget _buildFavorites(){
    if (favoriteProducts.isEmpty){
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

  Widget _buildProductCard(Product product){
    final isFavorite = favoriteProducts.contains(product);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
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
            ),
            Expanded(child: Image.asset(
              product.image,
              fit: BoxFit.contain,
            ),
            ),
            const SizedBox(height: 8),
            Text(product.name, style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            ),
            Text(product.status, style: const TextStyle(
              fontSize: 16,
             fontWeight: FontWeight.bold,
            ),
            ),
            Text('\$${product.price}', style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
