import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/amazon_fee_calculator.dart';
import '../widgets/fee_breakdown_card.dart';
import '../widgets/input_field.dart';

class AmazonCalculatorScreen extends StatefulWidget {
  const AmazonCalculatorScreen({super.key});

  @override
  State<AmazonCalculatorScreen> createState() => _AmazonCalculatorScreenState();
}

class _AmazonCalculatorScreenState extends State<AmazonCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sellingPriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedCategory = 'Electronics';
  String _fulfillmentType = 'FBA'; // FBA or FBM (Fulfillment by Amazon/Merchant)
  AmazonFeeResult? _result;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home & Kitchen',
    'Books',
    'Grocery & Gourmet',
    'Toys & Games',
    'Beauty & Health',
  ];

  final List<String> _fulfillmentTypes = ['FBA', 'FBM'];

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final sellingPrice = double.parse(_sellingPriceController.text);
      final costPrice = double.parse(_costPriceController.text);
      final weight = double.parse(_weightController.text);

      setState(() {
        _result = AmazonFeeCalculator.calculateFees(
          sellingPrice: sellingPrice,
          costPrice: costPrice,
          weight: weight,
          category: _selectedCategory,
          isFBA: _fulfillmentType == 'FBA',
        );
      });
    }
  }

  void _reset() {
    setState(() {
      _sellingPriceController.clear();
      _costPriceController.clear();
      _weightController.clear();
      _selectedCategory = 'Electronics';
      _fulfillmentType = 'FBA';
      _result = null;
    });
  }

  @override
  void dispose() {
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Amazon Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        controller: _sellingPriceController,
                        label: 'Selling Price (₹)',
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter selling price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: _costPriceController,
                        label: 'Cost Price (₹)',
                        icon: Icons.shopping_bag,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter cost price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        controller: _weightController,
                        label: 'Weight (kg)',
                        icon: Icons.monitor_weight,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          prefixIcon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _fulfillmentType,
                        decoration: InputDecoration(
                          labelText: 'Fulfillment Type',
                          prefixIcon: const Icon(Icons.local_shipping),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          helperText: 'FBA = Fulfillment by Amazon, FBM = Fulfillment by Merchant',
                        ),
                        items: _fulfillmentTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _fulfillmentType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              if (_result != null) ..[
                const SizedBox(height: 24),
                FeeBreakdownCard(
                  platformColor: Colors.amber.shade700,
                  sellingPrice: _result!.sellingPrice,
                  commissionFee: _result!.referralFee,
                  shippingFee: _result!.shippingFee,
                  gst: _result!.gst,
                  totalFees: _result!.totalFees,
                  costPrice: _result!.costPrice,
                  netProfit: _result!.netProfit,
                  profitMargin: _result!.profitMargin,
                  additionalFees: _result!.closingFee,
                  additionalFeesLabel: 'Closing Fee',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
