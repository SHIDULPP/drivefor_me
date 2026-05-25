import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class _VehicleItem {
  final String id;
  final String name;
  final String plate;
  final String transmission;

  const _VehicleItem({
    required this.id,
    required this.name,
    required this.plate,
    required this.transmission,
  });
}

class MyVehiclesPage extends StatefulWidget {
  const MyVehiclesPage({super.key});

  @override
  State<MyVehiclesPage> createState() => _MyVehiclesPageState();
}

class _MyVehiclesPageState extends State<MyVehiclesPage> {
  static const _dummyVehicles = [
    _VehicleItem(
      id: '1',
      name: 'Honda City',
      plate: 'KL 57 G 4575',
      transmission: 'Manual',
    ),
    _VehicleItem(
      id: '2',
      name: 'Honda City',
      plate: 'KL 57 G 4575',
      transmission: 'Manual',
    ),
    _VehicleItem(
      id: '3',
      name: 'Honda City',
      plate: 'KL 57 G 4575',
      transmission: 'Manual',
    ),
  ];

  late List<_VehicleItem> _vehicles = List.of(_dummyVehicles);

  void _removeVehicle(String id) {
    setState(() => _vehicles.removeWhere((v) => v.id == id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 22,
            color: kTextColor,
          ),
        ),
        title: Text(
          'My Vehicles',
          style: kStyle(kSemiBold, kSize18, color: kTextColor),
        ),
        titleSpacing: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: _vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final vehicle = _vehicles[index];
          return _VehicleCard(
            vehicle: vehicle,
            onDelete: () => _removeVehicle(vehicle.id),
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final _VehicleItem vehicle;
  final VoidCallback onDelete;

  const _VehicleCard({required this.vehicle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kTripBorder, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/pngs/car_image.png',
            width: 96,
            height: 52,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: kStyle(
                    kSemiBold,
                    kSize16,
                    color: kTextColor,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.plate,
                  style: kTripDurationPriceB,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  vehicle.transmission,
                  style: kStyle(
                    kRegular,
                    kSize14,
                    color: kMutedText,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDelete,
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.delete_outline, color: kRed, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
