import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/Profile/edits/reusable_edit_widgets.dart';
import 'package:hirebridge/models/jobseeker_edit_models.dart';

class EditSkillsPage extends StatefulWidget {
  final List<EditSkill> initialSkills;
  const EditSkillsPage({super.key, required this.initialSkills});

  @override
  State<EditSkillsPage> createState() => _EditSkillsPageState();
}

class _EditSkillsPageState extends State<EditSkillsPage> {
  late List<EditSkill> _skills;

  @override
  void initState() {
    super.initState();
    _skills = List.from(widget.initialSkills);
  }

  void _addSkill() {
    setState(() {
      _skills.add(EditSkill(name: 'New Skill'));
    });
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditPageLayout(
      title: 'Skills',
      subtitle: 'Tell us where you put this skill to use',
      onClose: () => Navigator.pop(context),
      onAdd: _addSkill,
      onSave: () => Navigator.pop(context, _skills),
      children: _skills.isEmpty
          ? [
              EmptyStateHint(
                message: 'No skills added yet.\nShare your expertise to attract employers.',
                onAdd: _addSkill,
              ),
            ]
          : _skills.asMap().entries.map((entry) {
              int idx = entry.key;
              EditSkill skill = entry.value;

              return EditCard(
                onDelete: () => _removeSkill(idx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: skill.name,
                      onChanged: (val) => skill.name = val,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Skill Name',
                        hintStyle: TextStyle(color: Colors.white30),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 10),
                    EditInputField(
                      label: 'Project name',
                      initialValue: skill.projectName,
                      onChanged: (val) => skill.projectName = val,
                    ),
                    EditInputField(
                      label: 'Work with',
                      initialValue: skill.workWith,
                      onChanged: (val) => skill.workWith = val,
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
