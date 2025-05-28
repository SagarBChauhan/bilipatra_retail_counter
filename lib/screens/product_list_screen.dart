import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/app_provider.dart';
import 'confirm_order_screen.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  List<ProductModel> get dummyProducts => [
        ProductModel(
            id: 'p1',
            name: 'Item A',
            price: 99.0,
            image:
                'https://magicstudio.com/blog/content/images/2023/10/props-product-photography.webp'),
        ProductModel(
            id: 'p2',
            name: 'Item B',
            price: 149.5,
            image:
                'https://magicstudio.com/blog/content/images/2023/10/props-product-photography.webp'),
        ProductModel(
            id: 'p3',
            name: 'Item C',
            price: 75.25,
            image:
                'https://magicstudio.com/blog/content/images/2023/10/props-product-photography.webp'),
        ProductModel(
            id: 'p4',
            name: 'Item D',
            price: 120.0,
            image:
                'https://magicstudio.com/blog/content/images/2023/10/props-product-photography.webp'),
        ProductModel(
            id: 'p5',
            name: 'Item E',
            price: 200.0,
            image:
                'https://magicstudio.com/blog/content/images/2023/10/props-product-photography.webp'),
      ];

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final selected = appProvider.selectedProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
                child: GridView.builder(
                  itemCount: dummyProducts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (MediaQuery.of(context).size.width ~/ 180).clamp(2, 5),
                    mainAxisExtent: 230,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (_, index) {
                    final product = dummyProducts[index];
                    final isSelected = selected.contains(product);
                    final qty = isSelected
                        ? selected.firstWhere((p) => p.id == product.id).quantity
                        : 0;
  
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹ ${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 6),
                            isSelected
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.green.shade50,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          onPressed: () => appProvider
                                              .decrementQuantity(product),
                                        ),
                                        Text('$qty',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          onPressed: () => appProvider
                                              .incrementQuantity(product),
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: () =>
                                        appProvider.addProduct(product),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('Add to Cart',
                                        style: GoogleFonts.poppins()),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ),
            if (selected.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Total: ₹ ${appProvider.totalPrice.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/confirm');
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text('Proceed to Confirm',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
