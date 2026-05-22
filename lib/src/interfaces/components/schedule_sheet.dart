import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_scheduled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Result from [showScheduleBottomSheet]: immediate pickup or a scheduled time.
class ScheduleSheetResult {
  final bool isNow;
  final DateTime? scheduledAt;

  const ScheduleSheetResult.now() : isNow = true, scheduledAt = null;

  const ScheduleSheetResult.scheduled(this.scheduledAt) : isNow = false;
}

Future<ScheduleSheetResult?> showScheduleBottomSheet(
  BuildContext context, {
  DateTime? initialDateTime,
  bool initialIsNow = false,
}) {
  return showModalBottomSheet<ScheduleSheetResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ScheduleBottomSheet(
        initialDateTime: initialDateTime,
        initialIsNow: initialIsNow,
      );
    },
  );
}

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime? initialDateTime;
  final bool initialIsNow;

  const ScheduleBottomSheet({
    super.key,
    this.initialDateTime,
    this.initialIsNow = false,
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  static const _dayCount = 60;
  static const _pickerItemExtent = 42.0;

  static final _pickupSummaryFormat = DateFormat('EEEE, d MMMM hh:mm a');
  static final _buttonScheduleFormat = DateFormat('d MMMM, hh:mm a');
  static final _dateColumnFormat = DateFormat('d EEE MMM');

  late bool _isNow;
  late List<DateTime> _days;
  late int _dateIndex;
  late int _hourIndex;
  late int _minuteIndex;
  late int _periodIndex;

  late FixedExtentScrollController _dateController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  final List<String> _hours = List.generate(
    12,
    (i) => (i + 1).toString().padLeft(2, '0'),
  );
  final List<String> _minutes = List.generate(
    60,
    (i) => i.toString().padLeft(2, '0'),
  );
  final List<String> _periods = ['AM', 'PM'];

  DateTime get _scheduledDateTime {
    final day = _days[_dateIndex];
    final hour12 = int.parse(_hours[_hourIndex]);
    final minute = int.parse(_minutes[_minuteIndex]);
    final isPm = _periodIndex == 1;
    var hour24 = hour12 % 12;
    if (isPm) hour24 += 12;

    return DateTime(day.year, day.month, day.day, hour24, minute);
  }

  @override
  void initState() {
    super.initState();
    _isNow = widget.initialIsNow;

    final now = DateTime.now();
    _days = List.generate(
      _dayCount,
      (i) => DateTime(now.year, now.month, now.day + i),
    );

    final initial =
        widget.initialDateTime ?? now.add(const Duration(minutes: 30));
    final initialDay = DateTime(initial.year, initial.month, initial.day);
    _dateIndex = _days.indexWhere(
      (d) =>
          d.year == initialDay.year &&
          d.month == initialDay.month &&
          d.day == initialDay.day,
    );
    if (_dateIndex < 0) _dateIndex = 0;

    _hourIndex = (initial.hour % 12 == 0 ? 12 : initial.hour % 12) - 1;
    _minuteIndex = initial.minute.clamp(0, 59);
    _periodIndex = initial.hour >= 12 ? 1 : 0;

    _dateController = FixedExtentScrollController(initialItem: _dateIndex);
    _hourController = FixedExtentScrollController(initialItem: _hourIndex);
    _minuteController = FixedExtentScrollController(initialItem: _minuteIndex);
    _periodController = FixedExtentScrollController(initialItem: _periodIndex);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final sheetHeight = _isNow
        ? MediaQuery.sizeOf(context).height * 0.62
        : MediaQuery.sizeOf(context).height * 0.88;

    return Container(
      height: sheetHeight,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'When do you need drive?',
                    style: kStyle(kSemiBold, kSize18, color: kTextColor),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: kTripCloseBtnBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 20, color: kTextColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _sheetToggle(
                    label: 'Now',
                    selected: _isNow,
                    onTap: () => setState(() => _isNow = true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _sheetToggle(
                    label: 'Schedule',
                    selected: !_isNow,
                    onTap: () => setState(() => _isNow = false),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _isNow ? _buildNowBody() : _buildScheduleBody()),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 16),
            child: _isNow ? _buildNowButton() : _buildScheduleButton(),
          ),
        ],
      ),
    );
  }

  Widget _sheetToggle({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? kTripSelectedTint : kWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kTripGold : kTripBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(label, style: kTripSegmentInactiveM),
      ),
    );
  }

  Widget _buildNowBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Image.asset(
            'assets/pngs/schedule_drive.png',
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: kStyle(kSemiBold, kSize20, color: kTextColor),
              children: [
                const TextSpan(text: 'Finding you a driver '),
                TextSpan(
                  text: 'Now!',
                  style: kStyle(kSemiBold, kSize20, color: kBrandBlue),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "We'll instantly search for nearby drivers and match you as soon as possible.",
            textAlign: TextAlign.center,
            style: kStyle(
              kRegular,
              kSize14,
              color: kTripBodyMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildScheduleBody() {
    final scheduled = _scheduledDateTime;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              style: kStyle(kRegular, kSize14, color: kTextColor),
              children: [
                const TextSpan(text: 'Pickup time: '),
                TextSpan(
                  text: _pickupSummaryFormat.format(scheduled),
                  style: kStyle(kSemiBold, kSize14, color: kTextColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 168,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildPicker(
                    controller: _dateController,
                    selectedIndex: _dateIndex,
                    itemCount: _days.length,
                    columnWidth: 96,
                    labelBuilder: (index) =>
                        _dateColumnFormat.format(_days[index]),
                    onChanged: (index) => setState(() => _dateIndex = index),
                  ),
                ),
                Expanded(
                  child: _buildPicker(
                    controller: _hourController,
                    selectedIndex: _hourIndex,
                    itemCount: _hours.length,
                    columnWidth: 52,
                    labelBuilder: (index) => _hours[index],
                    onChanged: (index) => setState(() => _hourIndex = index),
                  ),
                ),
                Expanded(
                  child: _buildPicker(
                    controller: _minuteController,
                    selectedIndex: _minuteIndex,
                    itemCount: _minutes.length,
                    columnWidth: 52,
                    labelBuilder: (index) => _minutes[index],
                    onChanged: (index) => setState(() => _minuteIndex = index),
                  ),
                ),
                Expanded(
                  child: _buildPicker(
                    controller: _periodController,
                    selectedIndex: _periodIndex,
                    itemCount: _periods.length,
                    columnWidth: 52,
                    labelBuilder: (index) => _periods[index],
                    onChanged: (index) => setState(() => _periodIndex = index),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: kTripBorder),
          _infoLine('Driver will be assigned before pickup'),
          const Divider(height: 1, thickness: 1, color: kTripBorder),
          _infoLine('Please schedule at least 30 minutes in advance.'),
          const Divider(height: 1, thickness: 1, color: kTripBorder),
          _infoLine('Free cancellation up to 60 mins before ride'),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Cancellation policy & terms',
              style: kStyle(kMedium, kSize13, color: kBrandBlue).copyWith(
                decoration: TextDecoration.underline,
                decorationColor: kBrandBlue,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _infoLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Text(text, style: kStyle(kRegular, kSize14, color: kTextColor)),
    );
  }

  Widget _buildNowButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context, const ScheduleSheetResult.now()),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kTripCtaBlue,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text('Set Pickup time to Now', style: kTripModalButtonM),
      ),
    );
  }

  Widget _buildScheduleButton() {
    final label =
        'Schedule at ${_buttonScheduleFormat.format(_scheduledDateTime)}';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                TripScheduledPage(scheduledAt: _scheduledDateTime),
          ),
        );
      },
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: kTripCtaBlue,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: kTripModalButtonM,
        ),
      ),
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int selectedIndex,
    required int itemCount,
    required String Function(int index) labelBuilder,
    required ValueChanged<int> onChanged,
    required double columnWidth,
  }) {
    return CupertinoPicker.builder(
      scrollController: controller,
      itemExtent: _pickerItemExtent,
      squeeze: 1.05,
      diameterRatio: 1.4,
      onSelectedItemChanged: onChanged,
      selectionOverlay: const SizedBox.shrink(),
      childCount: itemCount,
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        return Center(
          child: SizedBox(
            width: columnWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  labelBuilder(index),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isSelected
                      ? kTripPickerSelectedM
                      : kTripPickerUnselectedM,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 1.5,
                  width: columnWidth * 0.85,
                  color: isSelected ? kBrandBlue : kTripPickerMuted,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
