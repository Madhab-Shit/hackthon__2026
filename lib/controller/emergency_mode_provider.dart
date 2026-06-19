import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyModeProvider extends ChangeNotifier {
  static const String _storageKey = 'manual_emergency_mode';

  bool _manualEmergencyMode = false;
  bool _isLoaded = false;

  bool get manualEmergencyMode => _manualEmergencyMode;
  bool get isLoaded => _isLoaded;

  Future<void> load() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    _manualEmergencyMode = prefs.getBool(_storageKey) ?? false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setManualEmergencyMode(bool value) async {
    _manualEmergencyMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_storageKey, value);
  }

  bool shouldSuggestEmergency({
    required double remainingBudget,
    required int daysLeftInMonth,
  }) {
    if (daysLeftInMonth <= 0) return remainingBudget <= 0;
    return remainingBudget <= daysLeftInMonth * 120;
  }

  bool isEmergencyActive({
    required double remainingBudget,
    required int daysLeftInMonth,
  }) {
    return _manualEmergencyMode ||
        shouldSuggestEmergency(
          remainingBudget: remainingBudget,
          daysLeftInMonth: daysLeftInMonth,
        );
  }
}
