import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'dart:collection';

class CartData extends ChangeNotifier {
  List<Cart> _cartItems = [
    // Cart(name: "milk", price: 1),
    // Cart(name: "egg", price: 2),
  ];
  UnmodifiableListView<Cart> get carts {
    return UnmodifiableListView(_cartItems);
  }

  int get cartItemCount {
    return _cartItems.length;
  }

  void addItems(String? newTask, double? newPrice, int? newQuantity) {
    final task = Cart(name: newTask!, price: newPrice!, quantity: newQuantity!);
    _cartItems.add(task);
    notifyListeners();
  }

  void updateItem(Cart task) {
    task.toggleDone();
    notifyListeners();
  }

  void increaseQuantity(Cart task) {
    task.increaseQ();
    notifyListeners();
  }

  void decreaseQuantity(Cart task) {
    task.decreaseQ();
    notifyListeners();
  }

  void deleteTask(Cart task) {
    _cartItems.remove(task);
    notifyListeners();
  }

  void emptyCart() {
    _cartItems = [];
  }

  double getTotal() {
    double total = 0;
    for (int i = 0; i < carts.length; i++) {
      total =
          total + (carts[i].quantity * double.parse(carts[i].price.toString()));
    }

    return total;
  }
}
