import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/Profile/edits/reusable_edit_widgets.dart';
import 'package:hirebridge/models/jobseeker_edit_models.dart';

class EditEducationPage extends StatefulWidget {
  final List<EditEducation> initialEducation;
  const EditEducationPage({super.key, required this.initialEducation});

  @override
  State<EditEducationPage> createState() => _EditEducationPageState();
}

class _EditEducationPageState extends State<EditEducationPage> {
  late List<EditEducation> _education;

  @override
  void initState() {
    super.initState();
    _education = List.from(widget.initialEducation);
  }

  void _addEducation() {
    setState(() {
      _education.add(EditEducation(degree: 'Degree', institution: 'University', year: '2024'));
    });
  }

  void _removeEducation(int index) {
    setState(() {
      _education.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditPageLayout(
      title: 'Education',
      onClose: () => Navigator.pop(context),
      onAdd: _addEducation,
      onSave: () => Navigator.pop(context, _education),
      children: _education.isEmpty
          ? [
              EmptyStateHint(
                message: 'No education history found.\nAdd your degrees to showcase your qualifications.',
                onAdd: _addEducation,
              ),
            ]
          : _education.asMap().entries.map((entry) {
              int idx = entry.key;
              EditEducation edu = entry.value;

              return EditCard(
                onDelete: () => _removeEducation(idx),
                child: Column(
                  children: [
                    EditInputField(
                      label: 'Degree',
                      initialValue: edu.degree,
                      onChanged: (val) => edu.degree = val,
                    ),
                    EditInputField(
                      label: 'Institution',
                      initialValue: edu.institution,
                      onChanged: (val) => edu.institution = val,
                    ),
                    EditInputField(
                      label: 'Year',
                      initialValue: edu.year,
                      onChanged: (val) => edu.year = val,
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
