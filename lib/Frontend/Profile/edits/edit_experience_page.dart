import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/Profile/edits/reusable_edit_widgets.dart';
import 'package:hirebridge/models/jobseeker_edit_models.dart';

class EditExperiencePage extends StatefulWidget {
  final List<EditExperience> initialExperience;
  const EditExperiencePage({super.key, required this.initialExperience});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late List<EditExperience> _experience;

  @override
  void initState() {
    super.initState();
    _experience = List.from(widget.initialExperience);
  }

  void _addExperience() {
    setState(() {
      _experience.add(EditExperience(
        company: 'Company Name',
        role: 'Job Role',
        period: '2022 - Present',
        description: '',
      ));
    });
  }

  void _removeExperience(int index) {
    setState(() {
      _experience.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditPageLayout(
      title: 'Experience',
      onClose: () => Navigator.pop(context),
      onAdd: _addExperience,
      onSave: () => Navigator.pop(context, _experience),
      children: _experience.isEmpty
          ? [
              EmptyStateHint(
                message: 'No work experience added yet.\nHighlight your career journey to stand out.',
                onAdd: _addExperience,
              ),
            ]
          : _experience.asMap().entries.map((entry) {
              int idx = entry.key;
              EditExperience exp = entry.value;

              return EditCard(
                onDelete: () => _removeExperience(idx),
                child: Column(
                  children: [
                    EditInputField(
                      label: 'Company',
                      initialValue: exp.company,
                      onChanged: (val) => exp.company = val,
                    ),
                    EditInputField(
                      label: 'Role',
                      initialValue: exp.role,
                      onChanged: (val) => exp.role = val,
                    ),
                    EditInputField(
                      label: 'Period',
                      initialValue: exp.period,
                      onChanged: (val) => exp.period = val,
                    ),
                    EditInputField(
                      label: 'Description',
                      initialValue: exp.description,
                      onChanged: (val) => exp.description = val,
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
