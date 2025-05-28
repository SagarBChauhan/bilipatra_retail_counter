import 'package:bilipatra_retail_counter/services/invoice_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/app_provider.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await InvoiceGenerator.init();
  // InvoiceGenerator.preloadAssets();
  runApp(const BilipatraApp());
}

class BilipatraApp extends StatelessWidget {
  const BilipatraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Bilipatra Retail Counter',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade600),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
