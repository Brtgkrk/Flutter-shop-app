import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'models/product.dart';
import 'package:app1/product_detail_page.dart';
import 'cart_provider.dart';
import 'models/cart_item.dart';
import 'package:provider/provider.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return products.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = product.title;
              final price = product.price;
              final thumbnailUrl = product.thumbnail;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                leading: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ClipRect(
                    child: CachedNetworkImage(
                      imageUrl: thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircularProgressIndicator(),
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '\$$price',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    final cartItem = CartItem(
                      product: product,
                      quantity: 1,
                    );
                    cartProvider.addToCart(cartItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.title} added to cart')),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
              );
            },
          );
  }
}