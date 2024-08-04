import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/model/product.dart';
import 'package:flutter/material.dart';
import 'package:myapp/model/product.dart';


class CartProvider with ChangeNotifier {
  List<Product> _cart = [];
  double _amountGiven = 0.0;

  List<Product> get cart => _cart;

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void setAmountGiven(double amount) {
    _amountGiven = amount;
    notifyListeners();
  }

  double get totalPrice {
    return _cart.fold(0, (sum, item) => sum + item.price);
  }

  double get change {
    return _amountGiven - totalPrice;
  }

  double get amountGiven => _amountGiven;

  int getProductQuantity(Product product) {
    return _cart.where((p) => p == product).length;
  }
  void updateProductQuantities(List<Product> cart) {
  // Logika untuk mengurangi kuantitas produk
  for (var product in cart) {
    final currentProduct = Hive.box<Product>('products').get(product.key);
    if (currentProduct != null) {
      currentProduct.quantity -= 1; // Sesuaikan dengan logika kuantitas
      currentProduct.save();
    }
  }
}

}
