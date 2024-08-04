import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/pages/cart_page.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/quantity_provider.dart';

class AddToCartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
      },
      child: Text('View Cart'),
    );
  }
}