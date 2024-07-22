import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'https://flutter-product-app-81329-default-rtdb.firebaseio.com';
  final List<Product> products = [];

  //TODO hacer fetch
}
