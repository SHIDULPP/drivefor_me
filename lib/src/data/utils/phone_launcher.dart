import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhoneCall(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (cleaned.isEmpty) return;

  final uri = Uri(scheme: 'tel', path: cleaned);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    return;
  }

  // Fallback when package visibility hides dialer apps from canLaunchUrl.
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
