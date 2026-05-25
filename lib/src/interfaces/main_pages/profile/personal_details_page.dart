import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/interfaces/components/input_field.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';

class PersonalDetailsPage extends StatefulWidget {
  const PersonalDetailsPage({super.key});

  @override
  State<PersonalDetailsPage> createState() => _PersonalDetailsPageState();
}

class _PersonalDetailsPageState extends State<PersonalDetailsPage> {
  static const _avatarColor = Color(0xFFC18131);

  bool _isEditing = false;

  final _nameController = TextEditingController(text: 'Arun Kumar');
  final _mobileController = TextEditingController(text: '+6282359916');
  final _emailController = TextEditingController(text: 'arun@gmail.com');
  final _dobController = TextEditingController(text: '02/02/2002');
  final _genderController = TextEditingController(text: 'Male');

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = _nameController.text.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) return '?';
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name[0].toUpperCase();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _save() {
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
          'Personal Details',
          style: kStyle(kSemiBold, kSize18, color: kTextColor),
        ),
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _EditIconButton(
              isEditing: _isEditing,
              onTap: _isEditing ? _save : _toggleEdit,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: _avatarColor,
                    child: Text(
                      _initials,
                      style: kStyle(kSemiBold, kSize22, color: kWhite),
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_isEditing) ...[
                    _EditableField(
                      label: 'Name',
                      child: InputField(
                        type: CustomFieldType.text,
                        hint: 'Enter your name',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    _EditableField(
                      label: 'Mobile Number',
                      child: InputField(
                        type: CustomFieldType.number,
                        hint: 'Enter mobile number',
                        controller: _mobileController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    _EditableField(
                      label: 'Email',
                      child: InputField(
                        type: CustomFieldType.text,
                        hint: 'Enter your email',
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    _EditableField(
                      label: 'Date of Birth',
                      child: InputField(
                        type: CustomFieldType.date,
                        hint: 'DD-MM-YYYY',
                        controller: _dobController,
                      ),
                    ),
                    _EditableField(
                      label: 'Gender',
                      child: InputField(
                        type: CustomFieldType.text,
                        hint: 'Enter gender',
                        controller: _genderController,
                      ),
                    ),
                  ] else ...[
                    _DetailField(
                      label: 'Name',
                      value: _nameController.text,
                    ),
                    _DetailField(
                      label: 'Mobile Number',
                      value: _mobileController.text,
                    ),
                    _DetailField(
                      label: 'Email',
                      value: _emailController.text,
                    ),
                    _DetailField(
                      label: 'Date of Birth',
                      value: _dobController.text,
                    ),
                    _DetailField(
                      label: 'Gender',
                      value: _genderController.text,
                      showDivider: false,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_isEditing)
            Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 16),
              child: primaryButton(
                label: 'Save',
                onPressed: _save,
                buttonColor: kTripCtaBlue,
                buttonHeight: 54,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}

class _EditIconButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onTap;

  const _EditIconButton({
    required this.isEditing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kBrandBlue, width: 1.2),
          ),
          child: Icon(
            isEditing ? Icons.check_rounded : Icons.edit_outlined,
            size: 20,
            color: kBrandBlue,
          ),
        ),
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _DetailField({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: kSectionLabelR),
              const SizedBox(height: 8),
              Text(
                value,
                style: kStyle(kSemiBold, kSize16, color: kTextColor, height: 1.2),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: kLineGrey),
      ],
    );
  }
}

class _EditableField extends StatelessWidget {
  final String label;
  final Widget child;

  const _EditableField({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: kTripSubSectionSB),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
