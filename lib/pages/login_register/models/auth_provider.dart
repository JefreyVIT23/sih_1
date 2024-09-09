import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Private variables to store the phone number and login status.
  String _phoneNumber = '';
  bool _isLoggedIn = false;

  // Getter for the phone number.
  String get phoneNumber => _phoneNumber;

  // Getter to check if the user is logged in.
  bool get isLoggedIn => _isLoggedIn;

  // Method to log in the user.
  void login(String phoneNumber) {
    _phoneNumber = phoneNumber;  // Set the phone number.
    _isLoggedIn = true;          // Mark the user as logged in.
    notifyListeners();           // Notify listeners about the change.
  }

  // Method to log out the user.
  void logout() {
    _phoneNumber = '';           // Clear the phone number.
    _isLoggedIn = false;         // Mark the user as logged out.
    notifyListeners();           // Notify listeners about the change.
  }

  // Method to register the user.
  void register(String phoneNumber) {
    _phoneNumber = phoneNumber;  // Set the phone number.
    _isLoggedIn = true;          // Mark the user as logged in.
    notifyListeners();           // Notify listeners about the change.
  }
}
