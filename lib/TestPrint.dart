import 'dart:io';

import 'package:bilipatra_retail_counter/printerenum.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

///Test printing
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  sample() async {
    //image max 300px X 300px

    ///image from File path
    String filename = 'yourlogo.png';
    ByteData bytesData = await rootBundle.load("assets/images/yourlogo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/$filename').writeAsBytes(
      bytesData.buffer.asUint8List(
        bytesData.offsetInBytes,
        bytesData.lengthInBytes,
      ),
    );

    ///image from Asset
    ByteData bytesAsset = await rootBundle.load("assets/images/yourlogo.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer.asUint8List(
      bytesAsset.offsetInBytes,
      bytesAsset.lengthInBytes,
    );

    ///image from Network
    var response = await http.get(
      Uri.parse(
        "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png",
      ),
    );
    Uint8List bytesNetwork = response.bodyBytes;
    Uint8List imageBytesFromNetwork = bytesNetwork.buffer.asUint8List(
      bytesNetwork.offsetInBytes,
      bytesNetwork.lengthInBytes,
    );

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", Size.boldMedium.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printImage(file.path); //path of your image/logo
        bluetooth.printNewLine();
        bluetooth.printImageBytes(imageBytesFromAsset); //image from Asset
        bluetooth.printNewLine();
        bluetooth.printImageBytes(imageBytesFromNetwork); //image from Network
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.medium.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val);
        bluetooth.printLeftRight(
          "LEFT",
          "RIGHT",
          Size.bold.val,
          format: "%-15s %15s %n",
        ); //15 is number off character from left or right
        bluetooth.printNewLine();
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldMedium.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldLarge.val);
        bluetooth.printLeftRight("LEFT", "RIGHT", Size.extraLarge.val);
        bluetooth.printNewLine();
        bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val);
        bluetooth.print3Column(
          "Col1",
          "Col2",
          "Col3",
          Size.bold.val,
          format: "%-10s %10s %10s %n",
        ); //10 is number off character from left center and right
        bluetooth.printNewLine();
        bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val);
        bluetooth.print4Column(
          "Col1",
          "Col2",
          "Col3",
          "Col4",
          Size.bold.val,
          format: "%-8s %7s %7s %7s %n",
        );
        bluetooth.printNewLine();
        bluetooth.printCustom(
          "čĆžŽšŠ-H-ščđ",
          Size.bold.val,
          Align.center.val,
          charset: "windows-1250",
        );
        bluetooth.printLeftRight(
          "Številka:",
          "18000001",
          Size.bold.val,
          charset: "windows-1250",
        );
        bluetooth.printCustom("Body left", Size.bold.val, Align.left.val);
        bluetooth.printCustom("Body right", Size.medium.val, Align.right.val);
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You", Size.bold.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printQRcode(
          "Insert Your Own Text to Generate",
          200,
          200,
          Align.center.val,
        );
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)
        //bluetooth.drawerPin2(); // or you can use bluetooth.drawerPin5();
      }
    });
  }

  //   sample(String pathImage) async {
  //     //SIZE
  //     // 0- normal size text
  //     // 1- only bold text
  //     // 2- bold with medium text
  //     // 3- bold with large text
  //     //ALIGN
  //     // 0- ESC_ALIGN_LEFT
  //     // 1- ESC_ALIGN_CENTER
  //     // 2- ESC_ALIGN_RIGHT
  //
  // //     var response = await http.get("IMAGE_URL");
  // //     Uint8List bytes = response.bodyBytes;
  //     bluetooth.isConnected.then((isConnected) {
  //       if (isConnected == true) {
  //         bluetooth.printNewLine();
  //         bluetooth.printCustom("HEADER", 3, 1);
  //         bluetooth.printNewLine();
  //         bluetooth.printImage(pathImage); //path of your image/logo
  //         bluetooth.printNewLine();
  // //      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
  //         bluetooth.printLeftRight("LEFT", "RIGHT", 0);
  //         bluetooth.printLeftRight("LEFT", "RIGHT", 1);
  //         bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
  //         bluetooth.printNewLine();
  //         bluetooth.printLeftRight("LEFT", "RIGHT", 2);
  //         bluetooth.printLeftRight("LEFT", "RIGHT", 3);
  //         bluetooth.printLeftRight("LEFT", "RIGHT", 4);
  //         bluetooth.printNewLine();
  //         bluetooth.print3Column("Col1", "Col2", "Col3", 1);
  //         bluetooth.print3Column("Col1", "Col2", "Col3", 1,
  //             format: "%-10s %10s %10s %n");
  //         bluetooth.printNewLine();
  //         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
  //         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
  //             format: "%-8s %7s %7s %7s %n");
  //         bluetooth.printNewLine();
  //         String testString = " čĆžŽšŠ-H-ščđ";
  //         bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
  //         bluetooth.printLeftRight("Številka:", "18000001", 1,
  //             charset: "windows-1250");
  //         bluetooth.printCustom("Body left", 1, 0);
  //         bluetooth.printCustom("Body right", 0, 2);
  //         bluetooth.printNewLine();
  //         bluetooth.printCustom("Thank You", 2, 1);
  //         bluetooth.printNewLine();
  //         bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
  //         bluetooth.printNewLine();
  //         bluetooth.printNewLine();
  //         bluetooth.paperCut();
  //       }
  //     });
  //   }



  Future<void> printInvoice(dynamic user, List<dynamic> products) async {
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected != true) return;

    // DATE + INVOICE ID
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy HH:mm').format(now);
    final invoiceId = "INV${now.millisecondsSinceEpoch.toString().substring(7)}";
    ByteData bytesAsset = await rootBundle.load("assets/logo_min_gr.png");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);
    bluetooth.printImageBytes(imageBytesFromAsset); //image from Asset
    await Future.delayed(const Duration(milliseconds: 200));
    bluetooth.printNewLine();
    bluetooth.printCustom("Bilipatra Retail", Size.boldMedium.val, Align.center.val);
    bluetooth.printCustom("GSTIN: 27ABCDE1234F1Z5", Size.medium.val, Align.center.val);
    bluetooth.printCustom("F-2, Soham Pride,Nr. Time Square-Gauravpath, Besides DMART, TP 10 Main Rd, Pal Gam, Surat, Gujarat 395009", Size.medium.val, Align.center.val);
    bluetooth.printCustom("+91 91043 32327", Size.medium.val, Align.center.val);
    bluetooth.printCustom("care@bilipatra.com", Size.medium.val, Align.center.val);
    bluetooth.printCustom("INVOICE", Size.bold.val, Align.center.val);
    bluetooth.printCustom("--------------------------------", Size.medium.val, Align.center.val);

    bluetooth.printLeftRight("Invoice ID", invoiceId, Size.medium.val);
    bluetooth.printLeftRight("Date", formattedDate, Size.medium.val);

    bluetooth.printNewLine();
    bluetooth.printLeftRight("Customer", user.name ?? "-", Size.medium.val);
    bluetooth.printLeftRight("Phone", user.number ?? "-", Size.medium.val);
    bluetooth.printLeftRight("Address", user.address ?? "-", Size.medium.val);

    bluetooth.printNewLine();
    bluetooth.printCustom("Item              Qty     Amount", Size.bold.val, Align.left.val);
    bluetooth.printCustom("--------------------------------", Size.medium.val, Align.left.val);

    for (var item in products) {
      final total = item.price * item.quantity;
      final lines = _wrapText(item.name.toString(), 16); // wrap item name
      for (int i = 0; i < lines.length; i++) {
        if (i == 0) {
          final qty = "x${item.quantity}".padRight(5);
          final amt = "Rs. ${total.toStringAsFixed(2)}";
          bluetooth.printCustom("${lines[i].padRight(16)} $qty $amt", Size.medium.val, Align.left.val);
        } else {
          bluetooth.printCustom("${lines[i]}", Size.medium.val, Align.left.val);
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    bluetooth.printCustom("--------------------------------", Size.medium.val, Align.left.val);

    final double totalAmount = products.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    bluetooth.printLeftRight("Total", "Rs. ${totalAmount.toStringAsFixed(2)}", Size.bold.val);

    bluetooth.printNewLine();
    bluetooth.printCustom("Scan below to view digital bill", Size.medium.val, Align.center.val);

    // 🧾 QR code for bill (replace with actual URL generation logic)
    final billUrl = "https://bilipatra.com/bill/$invoiceId";
    await bluetooth.printQRcode(billUrl, 200, 200, Align.center.val);
    await Future.delayed(const Duration(milliseconds: 300));

    bluetooth.printCustom("--------------------------------", Size.medium.val, Align.center.val);
    bluetooth.printCustom("Thank You for Shopping!", Size.bold.val, Align.center.val);
    bluetooth.printCustom("Visit Again!", Size.bold.val, Align.center.val);
    bluetooth.printCustom("--------------------------------", Size.medium.val, Align.center.val);

    bluetooth.printNewLine();
    await bluetooth.paperCut();
    await bluetooth.disconnect();
  }
  List<String> _wrapText(String text, int width) {
    List<String> lines = [];
    while (text.length > width) {
      lines.add(text.substring(0, width));
      text = text.substring(width);
    }
    if (text.isNotEmpty) lines.add(text);
    return lines;
  }

}
