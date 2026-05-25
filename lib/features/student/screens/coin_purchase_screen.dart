import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/coin_service.dart';
import '../../../core/widgets/buttons/primary_button.dart';

class CoinPurchaseScreen extends StatefulWidget {
  const CoinPurchaseScreen({super.key});

  @override
  State<CoinPurchaseScreen> createState() => _CoinPurchaseScreenState();
}

class _CoinPurchaseScreenState extends State<CoinPurchaseScreen> {
  List<Map<String, dynamic>>? _packages;
  int? _selectedPackageIndex;
  bool _isLoading = true;
  bool _isCreatingOrder = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    setState(() => _isLoading = true);
    final pkgs = await CoinService.instance.getCoinPackages();
    setState(() {
      _packages = pkgs;
      _isLoading = false;
      if (pkgs.isNotEmpty) _selectedPackageIndex = 0;
    });
  }

  Future<void> _handlePurchase() async {
    if (_selectedPackageIndex == null || _packages == null) return;
    
    final pkg = _packages![_selectedPackageIndex!];
    setState(() => _isCreatingOrder = true);

    final result = await CoinService.instance.createPaymentOrder(pkg['coins']);
    
    if (!mounted) return;
    setState(() => _isCreatingOrder = false);

    if (result.success && result.order != null) {
      Navigator.of(context).pushNamed('/payment', arguments: result.order);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Failed to create order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Top Up Coins'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_packages == null || _packages!.isEmpty) {
      return const Center(child: Text('No coin packages available.'));
    }

    return Padding(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select a package to top up your account.',
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.xl),
          Expanded(
            child: ListView.builder(
              itemCount: _packages!.length,
              itemBuilder: (context, index) => _buildPackageCard(index),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          PrimaryButton(
            text: 'Purchase Now',
            onPressed: _handlePurchase,
            isLoading: _isCreatingOrder,
            backgroundColor: AppColors.primary,
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }

  Widget _buildPackageCard(int index) {
    final pkg = _packages![index];
    final isSelected = _selectedPackageIndex == index;
    final coins = pkg['coins'] as int;
    final fiat = pkg['fiat'] as int;
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return GestureDetector(
      onTap: () => setState(() => _selectedPackageIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.toll_rounded, 
                color: isSelected ? Colors.white : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$coins Coins',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    formatter.format(fiat),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
