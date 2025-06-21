import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../PrintScreen.dart';
import '../providers/app_provider.dart';

class OrderSuccessScreen extends StatelessWidget {
  final int orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  Future<void> _handlePrintInvoice(user, products) async {
    /*setState(() => _isLoading = true);
    try {
      await InvoiceGeneratorEzo.generateInvoicePdf(user, products);
    } catch (e) {
      debugPrint("Error generating PDF: $e");
    } finally {
      setState(() => _isLoading = false);
    }*/
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => PrintScreen(user: user, products: products),
    //   ),
    // );
  }

  Future<void> _generatePdfInBackground(user, products) async {
    await compute(generatePdfTask, {'user': user, 'products': products});
  }

  // Place this at the top level of your file or in another utils file
  Future<void> generatePdfTask(Map<String, dynamic> args) async {
    final user = args['user'];
    final products = args['products'];
    // await InvoiceGenerator.generateInvoicePdf(user, products);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final user = appProvider.user;
    final products = appProvider.selectedProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Placed"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                "Your order has been placed successfully!",
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text("Order ID: #$orderId"),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PrintScreen(user: user, products: products),
                    ),
                  );
                },
                icon: const Icon(Icons.print),
                label: const Text("Print Invoice"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  // await InvoiceGenerator.downloadAndSharePdf(user!, products);
                  // final whatsappUrl = Uri.encodeFull(
                  //   "https://wa.me/?text=Please find attached your invoice from Bilipatra Retail Counter.",
                  // );
                  // html.window.open(whatsappUrl, '_blank');
                },
                icon: const Icon(Icons.share),
                label: const Text("Send via WhatsApp"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
