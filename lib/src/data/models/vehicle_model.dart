class VehicleModel {
  final String id;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleType;
  final String transmission;

  const VehicleModel({
    required this.id,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.transmission,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      vehicleName: json['vehicleName'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      vehicleType: json['vehicleType'] as String? ?? '',
      transmission: json['transmission'] as String? ?? '',
    );
  }

  String get displayLabel => '$vehicleName • $vehicleNumber';
}
