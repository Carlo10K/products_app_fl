import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-product-app-81329-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final res = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(res.body);
    productsMap.forEach((key, value) {
      final temp = Product.fromMap(value);
      temp.id = key;
      products.add(temp);
    });

    isLoading = false;
    notifyListeners();
  }

  Future saveOrCreateProduct(Product product) async {
    if (product.id == null) {
      createProduct(product);
    } else {
      updateProduct(product);
    }
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    notifyListeners();

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final res = await http.post(url, body: product.toJson());
    final data = json.decode(res.body);

    product.id = data['name'];
    products.add(product);
    notifyListeners();

    return product.id!;
  }
}
