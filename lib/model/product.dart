import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double price;

  @HiveField(2)
  String category;

  @HiveField(3)
  int quantity;

  Product(
      {required this.name,
      required this.price,
      required this.category,
      required this.quantity});
}
