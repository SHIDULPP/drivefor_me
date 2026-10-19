import 'package:DriveForme/src/interfaces/main_pages/completed_trip_screens/raise_ticket_page.dart';
import 'package:flutter/material.dart';

// Preserve existing navigation links while sharing the ticket workflow.
class SupportCallPage extends StatelessWidget {
  const SupportCallPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const RaiseTicketPage(category: 'General Support');
}
