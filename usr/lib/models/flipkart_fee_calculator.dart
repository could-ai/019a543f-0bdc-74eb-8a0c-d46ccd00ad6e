class FlipkartFeeResult {
  final double sellingPrice;
  final double costPrice;
  final double commissionFee;
  final double shippingFee;
  final double gst;
  final double totalFees;
  final double netProfit;
  final double profitMargin;

  FlipkartFeeResult({
    required this.sellingPrice,
    required this.costPrice,
    required this.commissionFee,
    required this.shippingFee,
    required this.gst,
    required this.totalFees,
    required this.netProfit,
    required this.profitMargin,
  });
}

class FlipkartFeeCalculator {
  // Commission rates based on category (approximate Flipkart rates)
  static double _getCommissionRate(String category) {
    switch (category) {
      case 'Electronics':
        return 0.08; // 8%
      case 'Fashion':
        return 0.15; // 15%
      case 'Home & Furniture':
        return 0.15; // 15%
      case 'Books':
        return 0.10; // 10%
      case 'Grocery':
        return 0.05; // 5%
      case 'Toys':
        return 0.12; // 12%
      case 'Beauty & Personal Care':
        return 0.14; // 14%
      default:
        return 0.10; // 10% default
    }
  }

  // Shipping fee calculation based on weight
  static double _calculateShippingFee(double weight) {
    if (weight <= 0.5) {
      return 40.0; // ₹40 for up to 0.5kg
    } else if (weight <= 1.0) {
      return 55.0; // ₹55 for 0.5-1kg
    } else if (weight <= 2.0) {
      return 70.0; // ₹70 for 1-2kg
    } else if (weight <= 5.0) {
      return 100.0; // ₹100 for 2-5kg
    } else {
      return 100.0 + ((weight - 5.0) * 20.0); // ₹100 + ₹20 per additional kg
    }
  }

  static FlipkartFeeResult calculateFees({
    required double sellingPrice,
    required double costPrice,
    required double weight,
    required String category,
  }) {
    // Calculate commission fee
    final commissionRate = _getCommissionRate(category);
    final commissionFee = sellingPrice * commissionRate;

    // Calculate shipping fee
    final shippingFee = _calculateShippingFee(weight);

    // Calculate GST (18% on commission + shipping)
    final gst = (commissionFee + shippingFee) * 0.18;

    // Calculate total fees
    final totalFees = commissionFee + shippingFee + gst;

    // Calculate net profit
    final netProfit = sellingPrice - costPrice - totalFees;

    // Calculate profit margin percentage
    final profitMargin = (netProfit / sellingPrice) * 100;

    return FlipkartFeeResult(
      sellingPrice: sellingPrice,
      costPrice: costPrice,
      commissionFee: commissionFee,
      shippingFee: shippingFee,
      gst: gst,
      totalFees: totalFees,
      netProfit: netProfit,
      profitMargin: profitMargin,
    );
  }
}
