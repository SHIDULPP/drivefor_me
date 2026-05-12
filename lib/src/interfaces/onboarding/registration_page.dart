import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/providers/loading_provider.dart';
import 'package:driveforme_user/src/interfaces/animations/index.dart' as anim;
import 'package:driveforme_user/src/interfaces/components/input_field.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();

  String? _selectedGender;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: submit registration
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable content ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),

                      // ── Title ──────────────────────────────────────────
                      anim.AnimatedWidgetWrapper(
                        animationType: anim.AnimationType.fadeSlideInFromLeft,
                        duration: anim.AnimationDuration.normal,
                        child: Text(
                          'Create Account',
                          style: const TextStyle(
                            fontFamily: 'ClashGrotesk',
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: kTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      anim.AnimatedWidgetWrapper(
                        animationType: anim.AnimationType.fadeSlideInFromLeft,
                        duration: anim.AnimationDuration.normal,
                        delayMilliseconds: 80,
                        child: const Text(
                          "Let's get you started",
                          style: TextStyle(
                            fontFamily: 'ClashGrotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kSecondaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Full Name ──────────────────────────────────────
                      const _FieldLabel(label: 'Full Name'),
                      const SizedBox(height: 8),
                      anim.AnimatedWidgetWrapper(
                        animationType: anim.AnimationType.fadeSlideInFromBottom,
                        duration: anim.AnimationDuration.normal,
                        delayMilliseconds: 150,
                        child: InputField(
                          type: CustomFieldType.text,
                          hint: 'Enter your full name',
                          controller: _nameController,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? '' : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Email ──────────────────────────────────────────
                      const _FieldLabel(label: 'Email'),
                      const SizedBox(height: 8),
                      anim.AnimatedWidgetWrapper(
                        animationType: anim.AnimationType.fadeSlideInFromBottom,
                        duration: anim.AnimationDuration.normal,
                        delayMilliseconds: 200,
                        child: InputField(
                          type: CustomFieldType.text,
                          hint: 'Enter your email',
                          controller: _emailController,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return '';
                            final emailRegex = RegExp(
                              r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$',
                            );
                            return emailRegex.hasMatch(v.trim()) ? null : '';
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Date of Birth ──────────────────────────────────
                      const _FieldLabel(label: 'Date of Birth'),
                      const SizedBox(height: 8),
                      anim.AnimatedWidgetWrapper(
                        animationType: anim.AnimationType.fadeSlideInFromBottom,
                        duration: anim.AnimationDuration.normal,
                        delayMilliseconds: 250,
                        child: InputField(
                          type: CustomFieldType.date,
                          hint: 'DD-MM-YYYY',
                          controller: _dobController,
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? '' : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Gender ─────────────────────────────────────────
                      const _FieldLabel(label: 'Gender'),
                      const SizedBox(height: 8),
                      anim.AnimatedWidgetWrapper(
                        animationType: anim.AnimationType.fadeSlideInFromBottom,
                        duration: anim.AnimationDuration.normal,
                        delayMilliseconds: 300,
                        child: _GenderDropdown(
                          value: _selectedGender,
                          onChanged: (v) => setState(() => _selectedGender = v),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // ── Submit button pinned to bottom ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: anim.AnimatedWidgetWrapper(
                animationType: anim.AnimationType.fadeScaleUp,
                duration: anim.AnimationDuration.normal,
                delayMilliseconds: 350,
                child: primaryButton(
                  label: 'Submit',
                  buttonHeight: 56,
                  fontSize: 16,
                  onPressed: isLoading ? null : _handleSubmit,
                  isLoading: isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'ClashGrotesk',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: kTextColor,
      ),
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const _GenderDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      validator: (v) => (v == null || v.isEmpty) ? '' : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(
        fontFamily: 'ClashGrotesk',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: kTextColor,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF111111),
      ),
      dropdownColor: kWhite,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF5F5FA),
        hintText: 'Select gender',
        hintStyle: const TextStyle(
          fontFamily: 'ClashGrotesk',
          color: Color(0xFF9C9C9C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        errorStyle: const TextStyle(height: 0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Color(0xFFE8E8EF), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Color(0xFFE8E8EF), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
        DropdownMenuItem(value: 'Other', child: Text('Other')),
      ],
    );
  }
}
