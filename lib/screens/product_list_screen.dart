import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/app_provider.dart';
import '../services/api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ApiService _apiService;
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 20;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(context);
    _loadProducts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final results = await _apiService.productList(_currentPage, _pageSize);
      setState(() {
        _products.addAll(results.cast<ProductModel>());
        _hasMore = results.length == _pageSize;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
        child:
            _error != null
                ? Center(child: Text("Error: $_error"))
                : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        itemCount: _products.length + (_hasMore ? 1 : 0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (MediaQuery.of(context).size.width ~/
                                  180)
                              .clamp(2, 5),
                          mainAxisExtent: 250,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (_, index) {
                          if (index == _products.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final product = _products[index];
                          final isSelected = selected.contains(product);
                          final qty =
                              isSelected
                                  ? selected
                                      .firstWhere((p) => p.id == product.id)
                                      .quantity
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
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          product.image,
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const SizedBox(
                                              height: 90,
                                              width: 90,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              'assets/images/placeholder.jpg',
                                              // Make sure this file exists in your assets
                                              height: 90,
                                              width: 90,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    product.weight,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹ ${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  isSelected
                                      ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.green.shade50,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                              ),
                                              onPressed:
                                                  () => appProvider
                                                      .decrementQuantity(
                                                        product,
                                                      ),
                                            ),
                                            Text(
                                              '$qty',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                              ),
                                              onPressed:
                                                  () => appProvider
                                                      .incrementQuantity(
                                                        product,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : ElevatedButton(
                                        onPressed:
                                            () =>
                                                appProvider.addProduct(product),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Add to Cart',
                                          style: GoogleFonts.poppins(),
                                        ),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/confirm'),
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(
                            'Proceed to Confirm',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
      ),
    );
  }
}
