import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:products_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl =
      'flutter-product-app-81329-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  final storage = const FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;

  File? newPictureFile;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
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
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      createProduct(product);
    } else {
      updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    await http.put(url, body: product.toJson());

    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    notifyListeners();
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'idToken') ?? ''});
    final res = await http.post(url, body: product.toJson());
    final data = json.decode(res.body);

    product.id = data['name'];
    products.add(product);
    notifyListeners();
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/ditdb8p6g/image/upload?upload_preset=product_app_fl');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamRes = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamRes);

    if (res.statusCode != 200 && res.statusCode != 201) {
      return null;
    }

    newPictureFile = null;
    final data = json.decode(res.body);
    return data['secure_url'];
  }
}
