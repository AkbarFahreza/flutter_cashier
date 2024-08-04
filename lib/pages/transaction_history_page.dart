import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/transaction.dart';

class TransactionHistoryPage extends StatelessWidget {
  final Box<Transaction> transactionBox = Hive.box<Transaction>('transactions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (context, Box<Transaction> box, _) {
          List<Transaction> transactions = box.values.toList();

          if (transactions.isEmpty) {
            return Center(child: Text('No transactions found'));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = transactions[index];
              return Card(
                child: ListTile(
                  title: Text('Transaction ${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: transaction.products.map((product) {
                      return Text(
                          '${product.name} - ${product.quantity} x ${product.price}');
                    }).toList(),
                  ),
                  trailing: Text('Total: ${transaction.totalPrice}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
