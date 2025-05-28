import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/user_form_screen.dart';
import '../screens/product_list_screen.dart';
import '../screens/confirm_order_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'userForm',
      builder: (context, state) => const UserFormScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'productList',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/confirm',
      name: 'confirmOrder',
      builder: (context, state) => const ConfirmOrderScreen(),
    ),
  ],
);
