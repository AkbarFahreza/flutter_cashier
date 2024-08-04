import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/model/product.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cart.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          }

          Map<Product, int> productCounts = {};
          for (var product in cartProvider.cart) {
            if (productCounts.containsKey(product)) {
              productCounts[product] = productCounts[product]! + 1;
            } else {
              productCounts[product] = 1;
            }
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: productCounts.keys.length,
                  itemBuilder: (context, index) {
                    Product product = productCounts.keys.elementAt(index);
                    int quantity = productCounts[product]!;
                    return ListTile(
                      title: Text('${product.name} (${quantity} items)'),
                      subtitle: Text('Total: IDR ${product.price * quantity}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total: IDR ${cartProvider.totalPrice}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount Given',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    double? amount = double.tryParse(value);
                    if (amount != null) {
                      cartProvider.setAmountGiven(amount);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Change: IDR ${cartProvider.change}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    final amountGiven = cartProvider.amountGiven;
                    final totalPrice = cartProvider.totalPrice;

                    if (amountGiven >= totalPrice) {
                      // Simpan transaksi
                      final transaction = {
                        'items': cartProvider.cart
                            .map((p) => {
                                  'name': p.name,
                                  'quantity': cartProvider.cart
                                      .where((item) => item == p)
                                      .length,
                                  'total': p.price *
                                      cartProvider.cart
                                          .where((item) => item == p)
                                          .length
                                })
                            .toList(),
                        'total': totalPrice,
                        'amountGiven': amountGiven,
                        'change': cartProvider.change,
                        'date': DateTime.now().toIso8601String(),
                      };

                      print(
                          'Transaction: ${jsonEncode(transaction)}'); // Ganti dengan logika penyimpanan transaksi

                      cartProvider.updateProductQuantities(cartProvider.cart);
                      cartProvider.clearCart();
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Amount given is less than the total price')),
                      );
                    }
                  },
                  child: Text('Pay'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
