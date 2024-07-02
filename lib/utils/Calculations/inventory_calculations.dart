import 'package:intl/intl.dart';
import 'dart:math';
class InventoryCalculations {
  static getStockPerFactor(
      {required String factorType,
      required double factor,
      required double stock}) {
    double stockPerFactor = stock;
    if (factorType == 'D') {
      stockPerFactor = stock * factor;
    } else if (factorType == 'M') {
      stockPerFactor = stock / factor;
    }
    return stockPerFactor;
  }

  static roundOffQuantity({required double quantity}) {
    String roundedQuantity = quantity.toStringAsFixed(2);
    return roundedQuantity;
  }

  static String formatPrice(double price) {
    String formattedPrice =
        NumberFormat.currency(name: '', decimalDigits: 2).format(price);
    return formattedPrice;
  }
    static double roundHalfAwayFromZeroToDecimal(double value) {
    final multiplier = pow(10, 2).toDouble();
    final roundedValue =
        (value * multiplier + (value < 0 ? 0 : 0.5)).floor() / multiplier;
    return roundedValue;
  }

}
