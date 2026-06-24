class TripPriceEstimateModel {
  final double minimum;
  final double maximum;
  final String currency;
  final String? basisLabel;
  final bool includesWaitingTime;
  final double cashTotal;
  final double payOnlineTotal;
  final double baseFare;
  final double tripProtectionFee;
  final double gstAmount;

  const TripPriceEstimateModel({
    required this.minimum,
    required this.maximum,
    required this.currency,
    this.basisLabel,
    this.includesWaitingTime = false,
    required this.cashTotal,
    required this.payOnlineTotal,
    this.baseFare = 0,
    this.tripProtectionFee = 0,
    this.gstAmount = 0,
  });

  factory TripPriceEstimateModel.fromJson(Map<String, dynamic> json) {
    final priceEstimate = _asMap(json['priceEstimate']) ?? json;
    final breakdown = _asMap(json['breakdown']) ?? const {};
    final paymentTotals = _asMap(json['paymentTotals']) ?? const {};

    final minimum = _toDouble(priceEstimate['minimum']) ?? 0;
    final maximum = _toDouble(priceEstimate['maximum']) ?? minimum;

    return TripPriceEstimateModel(
      minimum: minimum,
      maximum: maximum,
      currency: priceEstimate['currency']?.toString() ?? 'INR',
      basisLabel: priceEstimate['basisLabel']?.toString(),
      includesWaitingTime: priceEstimate['includesWaitingTime'] == true,
      cashTotal: _toDouble(paymentTotals['cash']) ?? minimum,
      payOnlineTotal: _toDouble(paymentTotals['pay_online']) ?? minimum,
      baseFare: _toDouble(breakdown['baseFare']) ?? 0,
      tripProtectionFee: _toDouble(breakdown['tripProtectionFee']) ?? 0,
      gstAmount: _toDouble(breakdown['gstAmount']) ?? 0,
    );
  }

  String get displayAmount => _formatAmount(minimum);

  String totalForPaymentMethod(String paymentMethod) {
    final amount = paymentMethod == 'pay_online' ? payOnlineTotal : cashTotal;
    return _formatAmount(amount);
  }

  Map<String, dynamic> toPriceEstimatePayload() {
    return {
      'minimum': minimum,
      'maximum': maximum,
      'currency': currency,
      if (basisLabel != null && basisLabel!.isNotEmpty) 'basisLabel': basisLabel,
      'includesWaitingTime': includesWaitingTime,
    };
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String _formatAmount(double amount) {
    return '₹ ${amount.toStringAsFixed(0)}';
  }
}
