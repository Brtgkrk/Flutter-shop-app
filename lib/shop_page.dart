import 'dart:convert';
import 'package:app1/models/product.dart';
import 'package:app1/product_grid.dart';
import 'package:app1/product_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isGridMode = false;

  @override
  void initState() {
    super.initState();
    fetchProducts().then((response) {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<Product> productList = [];
        for (final productJson in json['products']) {
          final product = Product.fromJson(productJson);
          productList.add(product);
        }
        setState(() {
          products = productList;
        });
      }
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    final viewButtonIcon = isGridMode ? Icons.view_list : Icons.grid_view;

    return Scaffold(
      floatingActionButton: products.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  isGridMode = !isGridMode;
                });
              },
              child: Icon(viewButtonIcon),
            )
          : null,
      body: Column(
        children: [
          Container(
            //margin: const EdgeInsets.all(20),
            height: 80,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            color: const Color.fromARGB(255, 234, 234, 234),
            child: const Center(
              child: Text(
                'ShopExpress',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 36,
                  color: Colors.deepOrange,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: isGridMode
                  ? ProductGrid(products: products)
                  : ProductList(products: products),
            ),
          ),
        ],
      ),
    );
  }

  Future<http.Response> fetchProducts() {
    return http.get(Uri.parse('https://dummyjson.com/products'));
  }

  void fetchProductsNames() async {
    const url = 'https://dummyjson.com/products';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    final List<Product> productList = [];
    for (final productJson in json['products']) {
      final product = Product.fromJson(productJson);
      productList.add(product);
    }

    setState(() {
      products = productList;
    });
  }
}