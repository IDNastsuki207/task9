import 'package:flutter/foundation.dart';
import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => double.parse(product.price) * quantity;
}

class Cart with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => [..._items];
  
  int get itemCount => _items.length;
  
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product) {
    final existingItemIndex = _items.indexWhere((item) => item.product.name == product.name);
    
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(String productName) {
    _items.removeWhere((item) => item.product.name == productName);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(String productName, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.name == productName);
    if (index >= 0) {
      if (newQuantity > 0) {
        _items[index].quantity = newQuantity;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }
}