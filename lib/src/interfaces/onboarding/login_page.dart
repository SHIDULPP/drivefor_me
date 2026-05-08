import 'dart:developer';

import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/providers/screen_size_provider.dart';
import 'package:driveforme_user/src/interfaces//animations/index.dart' as anim;
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

final countryCodeProvider = StateProvider<String?>((ref) => '91');

class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  late TextEditingController _mobileController;
  late FocusNode _phoneFocusNode;
  bool _showPhoneError = false;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              anim.AnimatedWidgetWrapper(
                animationType: anim.AnimationType.fadeSlideInFromLeft,
                duration: anim.AnimationDuration.normal,
                child: Text('Verify Your Number', style: kHeadTitleR),
              ),
              SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        anim.AnimatedWidgetWrapper(
                          animationType:
                              anim.AnimationType.fadeSlideInFromBottom,
                          duration: anim.AnimationDuration.normal,
                          delayMilliseconds: 200,
                          child: IntlPhoneField(
                            focusNode: _phoneFocusNode,
                            validator: (phone) {
                              if (!_showPhoneError) {
                                return null;
                              }
                              if (phone == null || phone.number.isEmpty) {
                                return 'mobileNumberRequired';
                              }
                              // Validate that it contains only digits
                              if (!RegExp(r'^[0-9]+$').hasMatch(phone.number)) {
                                return 'mobileNumberDigitsOnly';
                              }
                              return null;
                            },
                            style: kSubHeadingR.copyWith(
                              fontSize: 25,
                              color: kGreyDark,
                            ),
                            controller: _mobileController,
                            disableLengthCheck: true,
                            showCountryFlag: false,
                            cursorColor: kBlack,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kBackgroundColor,
                              hintText: 'Mobile Number',
                              hintStyle: kSubHeadingR.copyWith(
                                fontSize: 25,
                                color: kGreyDark,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(8.0),
                              //   borderSide: BorderSide(color: kBorder),
                              // ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(8.0),
                              //   borderSide: BorderSide(color: kBorder),
                              // ),
                              // focusedBorder: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(8.0),
                              //   borderSide: const BorderSide(
                              //     color: kPrimaryColor,
                              //     width: 2.0,
                              //   ),
                              // ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 10.0,
                              ),
                            ),
                            onCountryChanged: (value) {
                              ref.read(countryCodeProvider.notifier).state =
                                  value.dialCode;
                            },
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              log(
                                'Phone number changed: ${phone.completeNumber}',
                                name: 'PhoneNumberScreen',
                              );
                            },
                            // flagsButtonPadding: const EdgeInsets.only(
                            //   left: 10,
                            //   right: 10.0,
                            // ),
                            showDropdownIcon: false,
                            // dropdownIcon: const Icon(
                            //   Icons.arrow_drop_down_outlined,
                            //   color: kTextColor,
                            // ),
                            // dropdownIconPosition: IconPosition.trailing,
                            dropdownTextStyle: const TextStyle(
                              color: kTextColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: anim.AnimatedWidgetWrapper(
                    animationType: anim.AnimationType.fadeScaleUp,
                    duration: anim.AnimationDuration.normal,
                    delayMilliseconds: 400,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: primaryButton(
                            label: 'Get OTP',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
