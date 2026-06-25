import 'dart:async';

import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/models/place_prediction_model.dart';
import 'package:driveforme_user/src/data/services/location_service.dart';
import 'package:driveforme_user/src/data/services/places_service.dart';
import 'package:flutter/material.dart';

class SearchLocationPage extends StatefulWidget {
  final String title;
  final bool showCurrentLocation;

  const SearchLocationPage({
    super.key,
    required this.title,
    this.showCurrentLocation = true,
  });

  @override
  State<SearchLocationPage> createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  static const _debounceDuration = Duration(milliseconds: 350);

  final TextEditingController _searchController = TextEditingController();
  final PlacesService _placesService = PlacesService();
  final LocationService _locationService = const LocationService();

  Timer? _debounce;
  List<PlacePrediction> _predictions = const [];
  bool _isSearching = false;
  bool _isResolvingSelection = false;
  bool _isFetchingCurrentLocation = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onQueryChanged);
    _searchController.dispose();
    _placesService.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, _runAutocomplete);
  }

  Future<void> _runAutocomplete() async {
    final query = _searchController.text.trim();
    if (query.length < 2) {
      if (!mounted) return;
      setState(() {
        _predictions = const [];
        _isSearching = false;
        _searchError = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    final predictions = await _placesService.autocomplete(query);
    if (!mounted) return;

    setState(() {
      _predictions = predictions;
      _isSearching = false;
      _searchError =
          predictions.isEmpty ? 'No places found. Try another search.' : null;
    });
  }

  Future<void> _selectPrediction(PlacePrediction prediction) async {
    setState(() {
      _isResolvingSelection = true;
      _searchError = null;
    });

    final location = await _placesService.placeDetails(prediction.placeId);
    if (!mounted) return;

    if (location == null || !location.hasCoordinates) {
      setState(() {
        _isResolvingSelection = false;
        _searchError = 'Could not load location details. Please try again.';
      });
      return;
    }

    Navigator.pop(context, location.toJson());
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isFetchingCurrentLocation = true;
      _searchError = null;
    });

    final location = await _locationService.getCurrentLocation();
    if (!mounted) return;

    if (location == null || !location.hasCoordinates) {
      setState(() {
        _isFetchingCurrentLocation = false;
        _searchError =
            'Unable to access your location. Check permissions and try again.';
      });
      return;
    }

    Navigator.pop(context, location.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim();
    final showSuggestions = query.length >= 2;

    return Scaffold(
      backgroundColor: kScreenBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 28,
                        color: kTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: kStyle(kSemiBold, 14, color: kTextColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: kWhite),
                child: Column(
                  children: [
                    const SizedBox(height: 26),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: kSearchFieldBg,
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(color: kLineGrey, width: 2),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              size: 30,
                              color: kTextColor,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                style: kStyle(kRegular, 16, color: kTextColor),
                                decoration: InputDecoration(
                                  hintText: 'Search for a place',
                                  hintStyle: kStyle(
                                    kLight,
                                    16,
                                    color: kMutedText,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            if (_isSearching || _isResolvingSelection)
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (widget.showCurrentLocation) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: GestureDetector(
                          onTap: _isFetchingCurrentLocation
                              ? null
                              : _useCurrentLocation,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.my_location,
                                size: 34,
                                color: kTextColor,
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Text(
                                  _isFetchingCurrentLocation
                                      ? 'Getting current location...'
                                      : 'Use current location',
                                  style: kStyle(
                                    kSemiBold,
                                    16,
                                    color: const Color(0xFF39463D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          showSuggestions ? 'SUGGESTIONS' : 'SEARCH',
                          style: kStyle(
                            kSemiBold,
                            16,
                            color: kMutedText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_searchError != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _searchError!,
                            style: kStyle(kRegular, 14, color: kMutedText),
                          ),
                        ),
                      ),
                    Expanded(
                      child: showSuggestions
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _predictions.length,
                              itemBuilder: (context, index) {
                                final prediction = _predictions[index];
                                return _LocationTile(
                                  title: prediction.title,
                                  subtitle: prediction.subtitle,
                                  onTap: _isResolvingSelection
                                      ? null
                                      : () => _selectPrediction(prediction),
                                );
                              },
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 38),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Start typing to search places in India.',
                                  style: kStyle(
                                    kRegular,
                                    14,
                                    color: kMutedText,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _LocationTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 28,
                    color: Color(0xFF121223),
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: kStyle(
                          kSemiBold,
                          16,
                          color: const Color(0xFF39463D),
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: kStyle(
                            kRegular,
                            14,
                            color: const Color(0xFF39463D),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 38, color: kChevronGrey),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kLineGrey),
        ],
      ),
    );
  }
}
