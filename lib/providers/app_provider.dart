import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/product.dart';

class AppProvider extends ChangeNotifier {
  UserModel? user;
  List<ProductModel> selectedProducts = [];

  void setUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  void addProduct(ProductModel product) {
    // Add a copy with quantity 1, avoid modifying dummy product directly
    selectedProducts.add(product.copyWith(quantity: 1));
    notifyListeners();
  }


  void clearCart() {
    selectedProducts.clear();
    notifyListeners();
  }

  void removeProduct(ProductModel product) {
    selectedProducts.remove(product);
    notifyListeners();
  }

  void incrementQuantity(ProductModel product) {
    final index = selectedProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      selectedProducts[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(ProductModel product) {
    final index = selectedProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      if (selectedProducts[index].quantity > 1) {
        selectedProducts[index].quantity--;
      } else {
        selectedProducts.removeAt(index);
      }
      notifyListeners();
    }
  }


  double get totalPrice {
    return selectedProducts.fold(
      0.0,
          (sum, item) => sum + (item.price * item.quantity),
    );
  }
}
