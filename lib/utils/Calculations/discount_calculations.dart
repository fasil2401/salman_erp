class DiscountHelper {
  static double calculateDiscount(
      {required double discountAmount,
      required double totalAmount,
      required bool isPercent}) {
    double result = 0.0;
    if (isPercent) {
      result = (totalAmount * discountAmount) / 100;
    } else {
      result = (discountAmount * 100) / totalAmount;
    }
   return result;
  }
}
