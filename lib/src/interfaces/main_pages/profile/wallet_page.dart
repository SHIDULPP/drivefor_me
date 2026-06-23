import 'package:driveforme_user/src/data/apis/wallet_api.dart';
import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/models/wallet_model.dart';
import 'package:driveforme_user/src/data/providers/wallet_provider.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletPage extends ConsumerStatefulWidget {
  final bool showReferralSection;

  const WalletPage({super.key, this.showReferralSection = true});

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  final _referralController = TextEditingController();
  bool _isApplyingReferral = false;

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _applyReferral() async {
    final code = _referralController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isApplyingReferral = true);
    final response =
        await ref.read(walletApiProvider).applyReferral(code);
    if (!mounted) return;
    setState(() => _isApplyingReferral = false);

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to apply code.')),
      );
      return;
    }

    ref.invalidate(walletProvider);
    _referralController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral code applied successfully.')),
    );
  }

  void _copyReferralCode(String code) {
    if (code.isEmpty) return;
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral code copied.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: kScreenBg,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0,
        title: Text('Wallet', style: kStyle(kSemiBold, kSize18, color: kBrandBlue)),
      ),
      body: walletAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$error', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(walletProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (wallet) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(walletProvider),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kBrandBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Balance',
                      style: kStyle(kRegular, kSize14, color: kWhite),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      wallet.displayBalance,
                      style: kStyle(kBold, kSize34, color: kWhite),
                    ),
                  ],
                ),
              ),
              if (widget.showReferralSection) ...[
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Refer & Earn',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Your referral code',
                        style: kStyle(kRegular, kSize13, color: kMutedText),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              wallet.referralCode.isEmpty
                                  ? '—'
                                  : wallet.referralCode,
                              style: kStyle(kSemiBold, kSize18, color: kTextColor),
                            ),
                          ),
                          IconButton(
                            onPressed: wallet.referralCode.isEmpty
                                ? null
                                : () => _copyReferralCode(wallet.referralCode),
                            icon: const Icon(Icons.copy_rounded, color: kBrandBlue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _referralController,
                        decoration: InputDecoration(
                          hintText: 'Enter referral code',
                          filled: true,
                          fillColor: kWhite,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: kCardBorder),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      primaryButton(
                        label: _isApplyingReferral ? 'Applying...' : 'Apply Code',
                        onPressed: _isApplyingReferral ? () {} : _applyReferral,
                        buttonColor: kBrandBlue,
                        buttonHeight: 48,
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text('Transactions', style: kStyle(kSemiBold, kSize16, color: kTextColor)),
              const SizedBox(height: 10),
              if (wallet.transactions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No transactions yet.',
                    textAlign: TextAlign.center,
                    style: kStyle(kRegular, kSize14, color: kMutedText),
                  ),
                )
              else
                ...wallet.transactions.map(
                  (tx) => _TransactionTile(transaction: tx),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kStyle(kSemiBold, kSize16, color: kTextColor)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kCardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description.isEmpty
                      ? transaction.category
                      : transaction.description,
                  style: kStyle(kSemiBold, kSize14, color: kTextColor),
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaction.category} • ${transaction.displayDate}',
                  style: kStyle(kRegular, kSize12, color: kMutedText),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                transaction.displayAmount,
                style: kStyle(
                  kSemiBold,
                  kSize14,
                  color: transaction.isCredit ? kActiveGreen : kRed,
                ),
              ),
              Text(
                'Bal ₹${transaction.balanceAfter.toStringAsFixed(0)}',
                style: kStyle(kRegular, kSize11, color: kMutedText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
