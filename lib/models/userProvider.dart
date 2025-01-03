import 'user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void removeUser() {
    _currentUser = null;
    notifyListeners();
  }
}