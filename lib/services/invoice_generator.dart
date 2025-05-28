import 'dart:html' as html; // Web only
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/product.dart';
import '../models/user.dart';
/*class InvoiceGenerator {
  static pw.ImageProvider? _logoImage;
  static pw.Font? _font;
  static pw.ImageProvider? _cachedLogo;

  static Future<void> preloadAssets() async {
    if (_cachedLogo == null) {
      _cachedLogo = await imageFromAssetBundle('logo_min.png');
    }
  }
  static Future<void> init() async {
    if (_logoImage == null) {
      _logoImage = await imageFromAssetBundle('logo_min.png');
    }
    if (_font == null) {
      _font = await fontFromAssetBundle('assets/fonts/NotoSans-Regular.ttf');
    }
  }

  static Future<void> generateInvoicePdf(UserModel user, List<ProductModel> products) async {
    await init(); // Ensure assets are loaded
    await preloadAssets(); // Make sure logo is preloaded
    final image = _cachedLogo!;

    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy – hh:mm a').format(now);
    final invoiceNumber = 'INV-${now.millisecondsSinceEpoch}';
    final total = products.fold(0.0, (sum, p) => sum + (p.price * p.quantity));
    final ttf = await fontFromAssetBundle('assets/fonts/NotoSans-Regular.ttf');
    // final image = await imageFromAssetBundle('logo_min.png');


    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with logo and title
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(height: 60, width: 60, child: pw.Image(image)),
                pw.Text(
                  'Invoice',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Bilipatra Retail Counter',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Customer Details:', style: pw.TextStyle(fontSize: 18)),
            pw.Text('Name: ${user.name}'),
            pw.Text('Phone: ${user.number}'),
            pw.Text('Address: ${user.address}'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Order Summary:',
              style: pw.TextStyle(fontSize: 18, font: ttf),
            ),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Product', 'Qty', 'Price (₹)', 'Total (₹)'],
              data:
              products
                  .map((p) => [p.name,
                p.quantity.toString(),
                p.price.toStringAsFixed(2),
                (p.quantity * p.price).toStringAsFixed(2),])
                  .toList(),
              headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
              cellStyle: pw.TextStyle(font: ttf),
            ),
            pw.SizedBox(height: 10),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Total: ₹ ${total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
            ),
          ],
        ),
      ),
    );


    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}*/

class InvoiceGenerator {
  static Future<void> generateInvoicePdf(
      UserModel user,
      List<ProductModel> products,
      ) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy – hh:mm a').format(now);
    final invoiceNumber = 'INV-${now.millisecondsSinceEpoch}';

    final total = products.fold(0.0, (sum, p) => sum + (p.price * p.quantity));

    // Load logo and custom font
    final image = await imageFromAssetBundle('logo_min.png');
    final ttf = await fontFromAssetBundle('assets/fonts/NotoSans-Regular.ttf');

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo and title
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(height: 60, width: 60, child: pw.Image(image)),
                  pw.Text(
                    'Invoice',
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Invoice number & date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice #: $invoiceNumber', style: pw.TextStyle(font: ttf)),
                  pw.Text('Date: $formattedDate', style: pw.TextStyle(font: ttf)),
                ],
              ),
              pw.SizedBox(height: 20),

              // Customer Info
              pw.Text(
                'Customer Information',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Name: ${user.name}', style: pw.TextStyle(font: ttf)),
              pw.Text('Phone: ${user.number}', style: pw.TextStyle(font: ttf)),
              pw.Text('Address: ${user.address}', style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 20),

              // Order Table
              pw.Text(
                'Order Summary',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Product', 'Qty', 'Price (₹)', 'Total (₹)'],
                headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                cellStyle: pw.TextStyle(font: ttf),
                cellAlignment: pw.Alignment.centerLeft,
                data: products
                    .map(
                      (p) => [
                    p.name,
                    p.quantity.toString(),
                    p.price.toStringAsFixed(2),
                    (p.quantity * p.price).toStringAsFixed(2),
                  ],
                )
                    .toList(),
              ),
              pw.SizedBox(height: 10),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: ₹ ${total.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                  ),
                ),
              ),
              pw.SizedBox(height: 24),

              // Payment Terms
              pw.Text(
                'Payment Details & Terms',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  font: ttf,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Mode of Payment: Cash / UPI / Card', style: pw.TextStyle(font: ttf)),
              pw.Text('Thank you for shopping with us.', style: pw.TextStyle(font: ttf)),
              pw.Text('Goods once sold will not be taken back.', style: pw.TextStyle(font: ttf)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static Future<Uint8List> generatePdfBytes(
    UserModel user,
    List<ProductModel> products,
  ) async {
    final pdf = pw.Document();
    double total = products.fold(0, (sum, p) => sum + p.price);
    final ttf = await fontFromAssetBundle('assets/fonts/NotoSans-Regular.ttf');

    pdf.addPage(
      pw.Page(
        build:
            (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Bilipatra Retail Counter',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Customer Details:', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Name: ${user.name}'),
                pw.Text('Phone: ${user.number}'),
                pw.Text('Address: ${user.address}'),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Order Summary:',
                  style: pw.TextStyle(fontSize: 18, font: ttf),
                ),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Product', 'Price (₹)'],
                  data:
                      products
                          .map((p) => [p.name, p.price.toStringAsFixed(2)])
                          .toList(),
                ),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Total: ₹ ${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                  ),
                ),
              ],
            ),
      ),
    );

    return pdf.save();
  }

  static Future<void> downloadAndSharePdf(
    UserModel user,
    List<ProductModel> products,
  ) async {
    final bytes = await generatePdfBytes(user, products);
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "invoice.pdf")
          ..click();

    html.Url.revokeObjectUrl(url);
  }
}
