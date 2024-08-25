import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laundry/model/LSCartModel.dart';

class LSCartProvider extends ChangeNotifier {
  List<LSCartModel> _cart = [];
  int _counter = 0;
  double _totalPrice = 0.0;

  LSCartProvider() {
    _loadCartData();
  }

  List<LSCartModel> get cart => _cart;
  int get counter => _counter;
  double get totalPrice => _totalPrice;

  Future<void> _loadCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cartCounter') ?? 0;
    _totalPrice = prefs.getDouble('cartTotalPrice') ?? 0.0;
    notifyListeners();
  }

  Future<void> _saveCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cartCounter', _counter);
    await prefs.setDouble('cartTotalPrice', _totalPrice);
  }

  void addCounter() {
    _counter++;
    _saveCartData();
    notifyListeners();
  }

  void removeCounter(int value) {
    if (_counter - value > 0) {
      _counter-= value;
    } else {
      _counter = 0;
    }
    _saveCartData();
    notifyListeners();
  }

  int getCounter() => _counter;

  void addTotalPrice(double price) {
    _totalPrice += price;
    _saveCartData();
    notifyListeners();
  }

  void removeTotalPrice(double price) {
    if (_totalPrice - price > 0) {
      _totalPrice -= price;
    } else {
      _totalPrice = 0.0;
    }
    _saveCartData();
    notifyListeners();
  }

  double getTotalPrice() => _totalPrice;

  void increaseQuantity(LSCartModel item) {
    item.quantity.value++;
    addCounter();
    addTotalPrice(item.productPrice);
    notifyListeners();
  }

  void decreaseQuantity(LSCartModel item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;
      removeCounter(1);
      removeTotalPrice(item.productPrice);
      notifyListeners();
    }
  }

  void removeItem(LSCartModel item) {
    removeCounter(item.quantity.value);
    removeTotalPrice(item.productPrice * item.quantity.value);
    notifyListeners();
    _cart.remove(item);
  }

  void clearCart() {
    _cart.clear();
    _counter = 0;
    _totalPrice = 0.0;
    _saveCartData();
    notifyListeners();
  }

}
