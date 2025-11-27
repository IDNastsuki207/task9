import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex =0;

  Set<Product> favoriteProducts = {};
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diputado E-commerce"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
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
            BottomNavigationBarItem(icon: Icon( Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon( Icons.favorite), label: "Favorite"),
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
          fontWeight: FontWeight.bold,
        ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _categoryButton("All Products", 0),
            _categoryButton("Jackets", 1),
            _categoryButton("Sneakers", 2),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(child: _buildProductGrid()),
      ],
    );
  }

  Widget _buildProductGrid(){
    List<Product> displayProducts;

    if(selectedIndex == 0){
      displayProducts = products;
    } else if (selectedIndex ==1){
      displayProducts = products.where((product) => product.category == 'Jackets').toList();
    } else {
      displayProducts = products.where((product) => product.category == 'Sneakers').toList();
    }

    return GridView.builder(
      itemCount: displayProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
        ),
      itemBuilder: (context, index){
        final product = displayProducts[index];
        return _buildProductCard(product);
      },
      );
  }

  Widget _categoryButton(String title, int index){
    return ElevatedButton(
      onPressed: () => setState(() => selectedIndex = index),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedIndex == index ? Colors.red : Colors.grey[200],
        foregroundColor: selectedIndex == index ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
      ),
      child: Text(title),
      );
  }

  Widget _buildFavorites(){
    if(favoriteProducts.isEmpty){
      return const Center(
        child: Text("No Favorite Products yet."),
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
      itemBuilder: (context, index){
        final product = favoriteProducts.elementAt(index);
        return _buildProductCard(product);
      },
      );
  }

  Widget _buildProductCard(Product product) {
  final isFavorited = favoriteProducts.contains(product);

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Favorite Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                setState(() {
                  isFavorited
                      ? favoriteProducts.remove(product)
                      : favoriteProducts.add(product);
                });
              },
            ),
          ),

          // Product Image
          Expanded(
            child: Center(
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Product Name
          Text(
            product.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          // Price
          Text(
            "\$${product.price}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // 🔥 QUANTITY + ADD TO CART
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity Selector
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (product.quantity > 1) product.quantity--;
                      });
                    },
                  ),
                  Text(
                    product.quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        product.quantity++;
                      });
                    },
                  ),
                ],
              ),

              // Add to Cart Button
              ElevatedButton(
                onPressed: () {
                  final cart = Provider.of<Cart>(context, listen: false);

                  // Add multiple quantities
                  for (int i = 0; i < product.quantity; i++) {
                    cart.addItem(product);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${product.quantity} × ${product.name} added to cart',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );

                  // Reset quantity after adding
                  setState(() {
                    product.quantity = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                child: const Text("Add"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}