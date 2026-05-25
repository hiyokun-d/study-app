import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/buttons/primary_button.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args == null) {
      return const Scaffold(body: Center(child: Text('Invalid payment data.')));
    }

    final orderId = args['order_id'] ?? 'Unknown';
    final coins = args['coins_amount'] ?? 0;
    final idr = args['idr_amount'] ?? 0;
    final qrUrl = args['qr_code_url'];
    final qrString = args['qr_string'];
    
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            // Order details
            Container(
              padding: const EdgeInsets.all(AppSizes.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Top Up $coins Coins',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatter.format(idr),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order ID: $orderId',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),

            // QRIS Section
            const Text(
              'Scan QRIS below to pay',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.md),
            
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${Uri.encodeComponent(qrString ?? 'https://lern.com')}',
                    width: 250,
                    height: 250,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        width: 250,
                        height: 250,
                        child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.md),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_rounded, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Text('Support all e-wallets & banks', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSizes.xl),
            
            const Text(
              'How to pay:',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.sm),
            _buildStep('1. Open your payment app (Gopay, OVO, ShopeePay, or Mobile Banking)'),
            _buildStep('2. Scan the QRIS code above'),
            _buildStep('3. Complete the payment in your app'),
            _buildStep('4. Coins will be added automatically once payment is confirmed'),

            const SizedBox(height: AppSizes.xl),
            
            PrimaryButton(
              text: 'I have paid',
              onPressed: () {
                // In a real app, you would poll the server or wait for a webhook
                // For now, let's go back and refresh balance
                Navigator.of(context).pop(); // Back to Coin Purchase
                Navigator.of(context).pop(); // Back to Profile
              },
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
        ],
      ),
    );
  }
}
