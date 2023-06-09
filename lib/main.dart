import 'package:app1/shop_page.dart';
import 'package:app1/profile_page.dart';
import 'package:app1/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const RootPage(),
      routes: {
        CartPage.routeName: (context) =>
            const CartPage(),
      },
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    setRefreshRate();
  }

  Future<void> setRefreshRate() async {
    await FlutterDisplayMode.setHighRefreshRate(); // 120hz on some phones
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: currentPage == 0
          ? const HomePage()
          : (currentPage == 1 ? const ProfilePage() : const CartPage()),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined), label: "Shop"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile"),
          NavigationDestination(
              icon: Icon(Icons.shopping_basket_outlined), label: "Cart"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
            debugPrint(currentPage.toString());
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}