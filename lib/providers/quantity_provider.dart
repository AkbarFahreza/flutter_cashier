import 'package:flutter/material.dart';
import 'package:myapp/model/product.dart';


class QuantityProvider with ChangeNotifier {
  Map<Product, int> _quantities = {};

  Map<Product, int> get quantities => _quantities;

  void increaseQuantity(Product product) {
    if (_quantities.containsKey(product)) {
      _quantities[product] = _quantities[product]! + 1;
    } else {
      _quantities[product] = 1;
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    if (_quantities.containsKey(product) && _quantities[product]! > 0) {
      _quantities[product] = _quantities[product]! - 1;
    }
    notifyListeners();
  }

  int getQuantity(Product product) {
    return _quantities[product] ?? 0;
  }

  void clearQuantities() {
    _quantities.clear();
    notifyListeners();
  }
}