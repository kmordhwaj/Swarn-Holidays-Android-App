// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ExpandText extends ChangeNotifier {
  bool _isExpanded = false;
  bool get isExpanded {
    return _isExpanded;
  }

  set isExpanded(bool status) {
    _isExpanded = status;
    notifyListeners();
  }
}
