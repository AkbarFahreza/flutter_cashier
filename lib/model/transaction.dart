import 'package:hive/hive.dart';
import 'product.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  List<Product> products;

  @HiveField(1)
  double totalPrice;

  Transaction({required this.products, required this.totalPrice});
}
