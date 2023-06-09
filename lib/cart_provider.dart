import 'package:flutter/foundation.dart';
import 'models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  int get itemCount => _cartItems.length;

  void addToCart(CartItem cartItem) {
    if (cartItems.isEmpty) {
      cartItems.add(cartItem);
    } else {
      final existingItemIndex = cartItems.indexWhere((item) => item.product.id == cartItem.product.id);
      if (existingItemIndex != -1) {
        cartItems[existingItemIndex].quantity += cartItem.quantity;
      } else {
        cartItems.add(cartItem);
      }
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  void increaseQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      removeFromCart(cartItem);
    }
    notifyListeners();
  }

  double calculateTotalPrice() {
    double total = 0;
    for (var cartItem in _cartItems) {
      total += cartItem.product.price * cartItem.quantity;
    }
    return total;
  }
}