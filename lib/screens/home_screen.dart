import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsService = Provider.of<ProductsService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    if (productsService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(title: const Text('productos'), actions: [
        IconButton(
          icon: const Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            authService.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ]),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: (context, int index) => GestureDetector(
              onTap: () {
                productsService.selectedProduct =
                    productsService.products[index].copy();
                Navigator.pushNamed(context, '/product');
              },
              child: ProductCard(product: productsService.products[index]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsService.selectedProduct =
              Product(available: false, name: '', price: 0);
          Navigator.pushNamed(context, '/product');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
