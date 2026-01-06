import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/Profile/edits/reusable_edit_widgets.dart';

class EditAboutPage extends StatefulWidget {
  final String initialAbout;
  const EditAboutPage({super.key, required this.initialAbout});

  @override
  State<EditAboutPage> createState() => _EditAboutPageState();
}

class _EditAboutPageState extends State<EditAboutPage> {
  late TextEditingController _aboutController;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.initialAbout);
    _calculateWordCount(widget.initialAbout);
  }

  void _calculateWordCount(String text) {
    if (text.isEmpty) {
      setState(() => _wordCount = 0);
      return;
    }
    final words = text.trim().split(RegExp(r'\s+'));
    setState(() => _wordCount = words.length);
  }

  @override
  Widget build(BuildContext context) {
    return EditPageLayout(
      title: 'Edit About',
      subtitle: 'Not more than 250 words',
      onClose: () => Navigator.pop(context),
      onAdd: () {}, // Not needed for About
      onSave: () {
        if (_wordCount > 250) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('About section cannot exceed 250 words')),
          );
          return;
        }
        Navigator.pop(context, _aboutController.text);
      },
      children: [
        const SizedBox(height: 20),
        EditInputField(
          label: 'About',
          controller: _aboutController,
          isLarge: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$_wordCount / 250 words',
            style: TextStyle(
              color: _wordCount > 250 ? Colors.red : Colors.white54,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }
}
