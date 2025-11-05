import 'package:flutter/material.dart';

class FeeBreakdownCard extends StatelessWidget {
  final Color platformColor;
  final double sellingPrice;
  final double commissionFee;
  final double shippingFee;
  final double gst;
  final double totalFees;
  final double costPrice;
  final double netProfit;
  final double profitMargin;
  final double? additionalFees;
  final String? additionalFeesLabel;

  const FeeBreakdownCard({
    super.key,
    required this.platformColor,
    required this.sellingPrice,
    required this.commissionFee,
    required this.shippingFee,
    required this.gst,
    required this.totalFees,
    required this.costPrice,
    required this.netProfit,
    required this.profitMargin,
    this.additionalFees,
    this.additionalFeesLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              platformColor.withOpacity(0.1),
              platformColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: platformColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Fee Breakdown',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: platformColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFeeRow('Selling Price', sellingPrice, isBold: true),
            const Divider(height: 24),
            Text(
              'Fees & Charges',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 12),
            _buildFeeRow('Commission Fee', commissionFee, isNegative: true),
            _buildFeeRow('Shipping Fee', shippingFee, isNegative: true),
            if (additionalFees != null && additionalFeesLabel != null)
              _buildFeeRow(additionalFeesLabel!, additionalFees!, isNegative: true),
            _buildFeeRow('GST (18%)', gst, isNegative: true),
            const Divider(height: 24),
            _buildFeeRow('Total Fees', totalFees, isNegative: true, isBold: true),
            const SizedBox(height: 8),
            _buildFeeRow('Cost Price', costPrice, isNegative: true),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: netProfit >= 0
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: netProfit >= 0
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Net Profit',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '₹${netProfit.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: netProfit >= 0 ? Colors.green : Colors.red,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profit Margin',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade700,
                            ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: netProfit >= 0
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${profitMargin.toStringAsFixed(2)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeRow(
    String label,
    double amount, {
    bool isNegative = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            '${isNegative ? '-' : ''}₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isBold ? 16 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isNegative ? Colors.red.shade700 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
