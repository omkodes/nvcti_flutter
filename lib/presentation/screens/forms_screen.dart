import 'package:flutter/material.dart';
import 'package:nvcti/domain/entities/form_item.dart';
import 'package:nvcti/presentation/common/form_list_card.dart';
// import 'package:url_launcher/url_launcher.dart'; // Recommended for opening links

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  // Mock Data
  final List<FormItem> _forms = [
    const FormItem(
      title: 'Event Proposal Form',
      url: 'https://docs.google.com/forms/...',
    ),
    const FormItem(
      title: 'Resource Booking Request',
      url: 'https://docs.google.com/forms/...',
    ),
  ];

  Future<void> _openFormUrl(String url) async {
    // Implementation for url_launcher:
    // final Uri uri = Uri.parse(url);
    // if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    //   throw Exception('Could not launch $url');
    // }
    print("Opening URL: $url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Or Colors.grey[50] depending on preference
      appBar: AppBar(
        title: const Text("Forms"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: _forms.length,
        itemBuilder: (context, index) {
          return FormListCard(
            formItem: _forms[index],
            onTap: () => _openFormUrl(_forms[index].url),
          );
        },
      ),
    );
  }
}
