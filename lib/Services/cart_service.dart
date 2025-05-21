import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void increaseQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    } else if (index >= 0) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.quantity);
}
