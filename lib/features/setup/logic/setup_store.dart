import 'package:flutter/foundation.dart';

class SetupStore extends ChangeNotifier {
  SetupStore._();
  static final SetupStore instance = SetupStore._();

  String? gender;
  int? age;
  double? weight;
  double? height;
  String? community;

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void setAge(int value) {
    age = value;
    notifyListeners();
  }

  void setWeight(double value) {
    weight = value;
    notifyListeners();
  }

  void setHeight(double value) {
    height = value;
    notifyListeners();
  }

  void setCommunity(String value) {
    community = value;
    notifyListeners();
  }

  bool get isComplete =>
      gender != null &&
      age != null &&
      weight != null &&
      height != null &&
      community != null;

  void clear() {
    gender = null;
    age = null;
    weight = null;
    height = null;
    community = null;
    notifyListeners();
  }
}