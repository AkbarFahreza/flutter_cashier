import 'package:flutter/material.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/quantity_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/model/product.dart';


class QuantityButtons extends StatelessWidget {
  final Product product;

  QuantityButtons({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            final quantityProvider = Provider.of<QuantityProvider>(context, listen: false);
            final cartProvider = Provider.of<CartProvider>(context, listen: false);
            
            quantityProvider.decreaseQuantity(product);
            if (quantityProvider.getQuantity(product) < cartProvider.getProductQuantity(product)) {
              cartProvider.removeFromCart(product);
            }
          },
        ),
        Consumer<QuantityProvider>(
          builder: (context, quantityProvider, child) {
            return Text(quantityProvider.getQuantity(product).toString());
          },
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            final quantityProvider = Provider.of<QuantityProvider>(context, listen: false);
            final cartProvider = Provider.of<CartProvider>(context, listen: false);
            
            final currentQuantity = quantityProvider.getQuantity(product);
            if (currentQuantity < product.quantity) {
              quantityProvider.increaseQuantity(product);
              cartProvider.addToCart(product);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cannot add more than available quantity')),
              );
            }
          },
        ),
      ],
    );
  }
}