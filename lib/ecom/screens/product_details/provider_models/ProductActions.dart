// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ProductActions extends ChangeNotifier {
  bool _productFavStatus = false;
  bool _productOwnedStatus = false;

  bool get productFavStatus {
    return _productFavStatus;
  }

  bool get productOwnedStatus {
    return _productOwnedStatus;
  }

  set initialProductFavStatus(bool status) {
    _productFavStatus = status;
  }

  set initialProductOwnedStatus(bool status) {
    _productOwnedStatus = status;
  }

  set productFavStatus(bool status) {
    _productFavStatus = status;
    notifyListeners();
  }

  set productOwnedStatus(bool status) {
    _productOwnedStatus = status;
    notifyListeners();
  }

  void switchProductFavStatus() {
    _productFavStatus = !_productFavStatus;
    notifyListeners();
  }

  void switchProductOwnedStatus() {
    _productOwnedStatus = !_productOwnedStatus;
    notifyListeners();
  }
}
