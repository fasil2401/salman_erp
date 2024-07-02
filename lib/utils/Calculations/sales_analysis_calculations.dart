class SalesAnalysisCalculations {
  static getGrossSale(
      {required dynamic cashSale,
      required dynamic creditSale,
      required dynamic cashSaleTax,
      required dynamic creditSaleTax}) {
    cashSale = cashSale == null ? 0 : cashSale;
    creditSale = creditSale == null ? 0 : creditSale;
    cashSaleTax = cashSaleTax == null ? 0 : cashSaleTax;
    creditSaleTax = creditSaleTax == null ? 0 : creditSaleTax;
    dynamic grossSale = cashSale + creditSale + cashSaleTax + creditSaleTax;
    return grossSale;
  }

  static getReturn(
      {required dynamic salesReturn,
      required dynamic taxReturn,
      required dynamic discountReturn,
      required dynamic roundOffReturn}) {
    salesReturn = salesReturn == null ? 0 : salesReturn;
    taxReturn = taxReturn == null ? 0 : taxReturn;
    discountReturn = discountReturn == null ? 0 : discountReturn;
    roundOffReturn = roundOffReturn == null ? 0 : roundOffReturn;
    dynamic returnAmount = salesReturn > 0
        ? salesReturn
        : 0.00 - taxReturn < 0
            ? taxReturn
            : 0.00 + discountReturn < 0
                ? discountReturn
                : 0.00 - roundOffReturn < 0
                    ? roundOffReturn
                    : 0.00;

    return returnAmount;
  }

  static getNetSale(
      {required dynamic grossSale,
      required dynamic returnAmount,
      required dynamic tax}) {
    grossSale = grossSale == null ? 0.00 : grossSale;
    returnAmount = returnAmount == null ? 0.00 : returnAmount;
    tax = tax == null ? 0.00 : tax;
    dynamic netSale = grossSale > 0
        ? grossSale
        : 0.00 - returnAmount > 0
            ? returnAmount
            : 0.00 - tax;
    return netSale;
  }

  static getNetProfit({required dynamic netSale, required dynamic cost}) {
    netSale = netSale == null ? 0.00 : netSale;
    cost = cost == null ? 0.00 : cost;
    dynamic netProfit = netSale - cost;
    return netProfit;
  }
}
