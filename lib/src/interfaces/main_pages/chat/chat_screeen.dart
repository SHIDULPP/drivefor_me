import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String participantName;

  const ChatScreen({
    super.key,
    this.participantName = 'Jacob John',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const _quickReplies = [
    "I've Arrived",
    "I'm on my way !",
    "Where are you ?",
  ];

  static const _chipBg = Color(0xFFF2F3F7);
  static const _inputBorder = Color(0xFFE2E2EC);

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  void _applyQuickReply(String text) {
    setState(() {
      _messageController.text = text;
      _messageController.selection = TextSelection.collapsed(
        offset: _messageController.text.length,
      );
    });
    _messageFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      appBar: _ChatAppBar(
        participantName: widget.participantName,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: Column(
        children: [
          const Expanded(child: SizedBox.expand()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                for (var i = 0; i < _quickReplies.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _QuickReplyChip(
                      label: _quickReplies[i],
                      onTap: () => _applyQuickReply(_quickReplies[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? 8 : 16),
            child: TextField(
              controller: _messageController,
              focusNode: _messageFocus,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _messageController.clear(),
              style: kStyle(kRegular, kSize15, color: kTextColor),
              decoration: InputDecoration(
                hintText: 'Type your message',
                hintStyle: kStyle(kRegular, kSize15, color: kTripMutedLabel),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: kWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _inputBorder, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _inputBorder, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _inputBorder, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String participantName;
  final VoidCallback onBack;

  const _ChatAppBar({
    required this.participantName,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kWhite,
      surfaceTintColor: kWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: Material(
            color: kTripCloseBtnBg,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.chevron_left_rounded,
                  size: 28,
                  color: kTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            participantName,
            style: kStyle(kSemiBold, kSize16, color: kTextColor),
          ),
          const SizedBox(height: 2),
          Text('Chat', style: kStyle(kRegular, kSize13, color: kTripMutedLabel)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_horiz_rounded,
            size: 26,
            color: kTextColor,
          ),
          padding: const EdgeInsets.only(right: 8),
        ),
      ],
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickReplyChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _ChatScreenState._chipBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 11),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: kStyle(kRegular, kSize12, color: kTextColor),
            ),
          ),
        ),
      ),
    );
  }
}
