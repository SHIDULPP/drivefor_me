import 'package:driveforme_user/src/data/apis/support_api.dart';
import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/interfaces/components/input_field.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RaiseTicketPage extends ConsumerStatefulWidget {
  final String tripId;
  final String? tripMongoId;
  final String category;

  const RaiseTicketPage({
    super.key,
    this.tripId = '—',
    this.tripMongoId,
    this.category = 'General Support',
  });

  @override
  ConsumerState<RaiseTicketPage> createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends ConsumerState<RaiseTicketPage> {
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();
    if (subject.isEmpty || description.isEmpty) return;

    setState(() => _isSubmitting = true);

    final tripMongoId = widget.tripMongoId ??
        (isMongoObjectId(widget.tripId) ? widget.tripId : null);

    final response = await ref.read(supportApiProvider).createTicket(
          category: widget.category,
          subject: subject,
          description: description,
          tripMongoId: tripMongoId,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (!response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? 'Failed to submit ticket.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support ticket submitted successfully.')),
    );
    Navigator.of(context).pop({
      'subject': subject,
      'description': description,
      'tripId': widget.tripId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kScreenBg,
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
          'Raise a ticket',
          style: kStyle(kSemiBold, kSize18, color: kTextColor),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject', style: kTripSubSectionSB),
                  const SizedBox(height: 12),
                  InputField(
                    type: CustomFieldType.text,
                    hint: 'Enter your subject',
                    controller: _subjectController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 28),
                  Text('Description', style: kTripSubSectionSB),
                  const SizedBox(height: 12),
                  InputField(
                    type: CustomFieldType.text,
                    hint: 'Type your description here...',
                    controller: _descriptionController,
                    maxLines: 6,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 16),
            child: primaryButton(
              label: 'Submit',
              onPressed: _isSubmitting ? null : _submit,
              isLoading: _isSubmitting,
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
