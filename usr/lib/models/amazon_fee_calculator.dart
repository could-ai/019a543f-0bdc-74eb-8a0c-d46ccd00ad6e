class AmazonFeeResult {
  final double sellingPrice;
  final double costPrice;
  final double referralFee;
  final double shippingFee;
  final double closingFee;
  final double gst;
  final double totalFees;
  final double netProfit;
  final double profitMargin;

  AmazonFeeResult({
    required this.sellingPrice,
    required this.costPrice,
    required this.referralFee,
    required this.shippingFee,
    required this.closingFee,
    required this.gst,
    required this.totalFees,
    required this.netProfit,
    required this.profitMargin,
  });
}

class AmazonFeeCalculator {
  // Referral fee rates based on category (approximate Amazon India rates)
  static double _getReferralRate(String category) {
    switch (category) {
      case 'Electronics':
        return 0.08; // 8%
      case 'Fashion':
        return 0.15; // 15%
      case 'Home & Kitchen':
        return 0.15; // 15%
      case 'Books':
        return 0.10; // 10%
      case 'Grocery & Gourmet':
        return 0.05; // 5%
      case 'Toys & Games':
        return 0.12; // 12%
      case 'Beauty & Health':
        return 0.13; // 13%
      default:
        return 0.10; // 10% default
    }
  }

  // FBA shipping fee calculation based on weight
  static double _calculateFBAShippingFee(double weight) {
    if (weight <= 0.5) {
      return 45.0; // ₹45 for up to 0.5kg
    } else if (weight <= 1.0) {
      return 60.0; // ₹60 for 0.5-1kg
    } else if (weight <= 2.0) {
      return 80.0; // ₹80 for 1-2kg
    } else if (weight <= 5.0) {
      return 120.0; // ₹120 for 2-5kg
    } else {
      return 120.0 + ((weight - 5.0) * 25.0); // ₹120 + ₹25 per additional kg
    }
  }

  // FBM (self-ship) shipping fee calculation
  static double _calculateFBMShippingFee(double weight) {
    if (weight <= 0.5) {
      return 35.0; // ₹35 for up to 0.5kg
    } else if (weight <= 1.0) {
      return 50.0; // ₹50 for 0.5-1kg
    } else if (weight <= 2.0) {
      return 65.0; // ₹65 for 1-2kg
    } else if (weight <= 5.0) {
      return 95.0; // ₹95 for 2-5kg
    } else {
      return 95.0 + ((weight - 5.0) * 18.0); // ₹95 + ₹18 per additional kg
    }
  }

  // Closing fee (fixed fee for certain categories)
  static double _getClosingFee(String category, double sellingPrice) {
    // Closing fee applies differently based on category and price
    if (sellingPrice <= 250) {
      return 4.0; // ₹4 for items ≤ ₹250
    } else if (sellingPrice <= 500) {
      return 9.0; // ₹9 for items ≤ ₹500
    } else if (sellingPrice <= 1000) {
      return 26.0; // ₹26 for items ≤ ₹1000
    } else {
      return 61.0; // ₹61 for items > ₹1000
    }
  }

  static AmazonFeeResult calculateFees({
    required double sellingPrice,
    required double costPrice,
    required double weight,
    required String category,
    required bool isFBA,
  }) {
    // Calculate referral fee
    final referralRate = _getReferralRate(category);
    final referralFee = sellingPrice * referralRate;

    // Calculate shipping fee based on fulfillment type
    final shippingFee = isFBA
        ? _calculateFBAShippingFee(weight)
        : _calculateFBMShippingFee(weight);

    // Calculate closing fee
    final closingFee = _getClosingFee(category, sellingPrice);

    // Calculate GST (18% on referral fee + shipping fee + closing fee)
    final gst = (referralFee + shippingFee + closingFee) * 0.18;

    // Calculate total fees
    final totalFees = referralFee + shippingFee + closingFee + gst;

    // Calculate net profit
    final netProfit = sellingPrice - costPrice - totalFees;

    // Calculate profit margin percentage
    final profitMargin = (netProfit / sellingPrice) * 100;

    return AmazonFeeResult(
      sellingPrice: sellingPrice,
      costPrice: costPrice,
      referralFee: referralFee,
      shippingFee: shippingFee,
      closingFee: closingFee,
      gst: gst,
      totalFees: totalFees,
      netProfit: netProfit,
      profitMargin: profitMargin,
    );
  }
}
