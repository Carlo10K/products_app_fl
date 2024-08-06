import 'package:flutter/material.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/services/services.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => AuthService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: '/checking',
      routes: {
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/product': (_) => const ProductScreen(),
        '/login': (_) => const LoginScreen(),
        '/checking': (_) => const CheckAuthScreen()
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(
              color: Colors.indigo,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
              centerTitle: true),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.indigo)),
    );
  }
}
