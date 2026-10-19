import 'dart:typed_data';

import 'package:DriveForme/src/data/apis/vehicle_api.dart';
import 'package:DriveForme/src/data/services/vehicle_document_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class VehicleDocumentField extends ConsumerStatefulWidget {
  const VehicleDocumentField({
    super.key,
    required this.type,
    required this.label,
    required this.onChanged,
    required this.onBusyChanged,
    this.enabled = true,
  });
  final String type;
  final String label;
  final ValueChanged<String?> onChanged;
  final ValueChanged<bool> onBusyChanged;
  final bool enabled;

  @override
  ConsumerState<VehicleDocumentField> createState() =>
      _VehicleDocumentFieldState();
}

class _VehicleDocumentFieldState extends ConsumerState<VehicleDocumentField> {
  bool _busy = false;
  Uint8List? _preview;
  String? _url;
  String? _message;
  bool _valid = false;

  Future<void> _pick() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose photo'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    await _run(() async {
      final file = await ImagePicker().pickImage(
        source: source,
        imageQuality: 90,
      );
      if (file == null || !mounted) return;
      widget.onChanged(null);
      setState(() {
        _valid = false;
        _url = null;
        _message = null;
      });
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() => _preview = bytes);
      final url = await ref
          .read(vehicleDocumentUploadServiceProvider)
          .upload(file);
      if (!mounted) return;
      _url = url;
      await _verify();
    });
  }

  Future<void> _verify() async {
    final response = await ref
        .read(vehicleApiProvider)
        .extractDocument(widget.type, _url!);
    if (!mounted) return;
    final doc = response.data;
    final valid =
        response.success &&
        doc != null &&
        doc['problem'] == null &&
        doc['isReadable'] != false &&
        doc['isExpectedDocument'] != false &&
        doc['expiryDate'] != null &&
        ['valid', 'expiring_soon'].contains(doc['status']);
    setState(() {
      _valid = valid;
      _message = !response.success
          ? response.message ?? 'Could not check document. Retry.'
          : doc?['problem']?.toString() ??
                (doc?['status'] == 'expired'
                    ? 'Expired on ${doc?['expiryDate']}. Upload a renewed copy.'
                    : valid
                    ? '${doc['status'] == 'expiring_soon' ? 'Expiring soon' : 'Expires'}: ${doc['expiryDate']}'
                    : 'Could not read this document. Upload a clear, complete copy.');
    });
    widget.onChanged(valid ? _url : null);
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    widget.onBusyChanged(true);
    try {
      await action();
    } catch (error) {
      if (mounted)
        setState(
          () => _message =
              'Unable to upload or check document. ${error.toString().replaceFirst('Exception: ', '')}',
        );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
        widget.onBusyChanged(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.label} *',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          if (_preview != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Image.memory(
                _preview!,
                height: 100,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _message!,
                style: TextStyle(
                  color: _valid ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
            ),
          if (_busy)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Text('Uploading and checking document…')),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: widget.enabled ? _pick : null,
                  icon: Icon(
                    _valid ? Icons.check_circle_outline : Icons.upload_file,
                  ),
                  label: Text(
                    _preview == null ? 'Upload JPG / PNG' : 'Replace photo',
                  ),
                ),
                if (_url != null && !_valid)
                  TextButton(
                    onPressed: widget.enabled ? () => _run(_verify) : null,
                    child: const Text('Retry check'),
                  ),
              ],
            ),
        ],
      ),
    ),
  );
}
