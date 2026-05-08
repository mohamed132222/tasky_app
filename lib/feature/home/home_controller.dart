import 'package:flutter/material.dart';
import 'package:tasky_app/core/constant/storage_key.dart';
import 'package:tasky_app/core/services/preferences_manager.dart';

class HomeController with ChangeNotifier {
  String? username = "Default";
  String? quote = "Default";
  bool isLoading = false;
  String? imagePath;

  void init() {
    loadUserData();
  }

  void loadUserData() async {
    isLoading = true;

    username = PreferencesManager().getString(StorageKey.userName);
    quote = PreferencesManager().getString(StorageKey.quote);
    imagePath = PreferencesManager().getString(StorageKey.imagePath);
    isLoading = false;
    notifyListeners();
  }
}
