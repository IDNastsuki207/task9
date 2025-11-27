class Product {
  final String name;
  final String price;
  final String status;
  final String image;
  final String category;

  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.status,
    required this.image,
    required this.category,
    this.quantity = 1,
  });
}

final List<Product> products = [
  Product(
    name: 'Brown Leather Oxford',
    price: '140.00',
    status: 'New Arrival',
    image: 'assets/shoe1.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Nike Air Zoom Pegasus',
    price: '180.00',
    status: 'In Stock',
    image: 'assets/shoe2.jpg',
    category: 'Sneakers',
  ),
  Product(
    name: 'Gray Bomber Jacket',
    price: '75.00',
    status: 'Limited Edition',
    image: 'assets/jacket1.jpg',
    category: 'Jackets',
  ),
  Product(
    name: 'Blue Denim Jacket',
    price: '95.00',
    status: 'On Sale',
    image: 'assets/jacket2.jpg',
    category: 'Jackets',
  ),
];
