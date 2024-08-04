import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/model/product.dart';
import 'package:myapp/components/product_form.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'transaction_history_page.dart';
import 'cart_page.dart';
import 'package:myapp/components/quantity_buttons.dart';
import 'package:myapp/components/add_to_cart_button.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/quantity_provider.dart';


class MainPage extends StatelessWidget {
  final Box<Product> productBox = Hive.box<Product>('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasir App'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionHistoryPage()),
              );
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => QuantityProvider(),
        child: ValueListenableBuilder(
          valueListenable: productBox.listenable(),
          builder: (context, Box<Product> box, _) {
            List<Product> products = box.values.toList();

            return Column(
              children: [
                if (products.isNotEmpty) FilterCategories(products: products),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      Product product = products[index];
                      return Dismissible(
                        key: Key(product.key.toString()),
                        background: Container(color: Colors.red),
                        secondaryBackground: Container(color: Colors.green),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            product.delete();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProductForm(product: product)),
                            );
                          }
                        },
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text('${product.price} - ${product.category}'),
                          trailing: QuantityButtons(product: product),
                        ),
                      );
                    },
                  ),
                ),
                CartSummary(),
                AddToCartButton(),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductForm()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FilterCategories extends StatelessWidget {
  final List<Product> products;

  FilterCategories({required this.products});

  @override
  Widget build(BuildContext context) {
    List<String> categories = products.map((p) => p.category).toSet().toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((category) {
        return ElevatedButton(
          onPressed: () {
            // Filter logic
          },
          child: Text(category),
        );
      }).toList(),
    );
  }
}

class CartSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          padding: EdgeInsets.all(8.0),
          child: Text('Total items: ${cart.cart.length}'),
        );
      },
    );
  }
}