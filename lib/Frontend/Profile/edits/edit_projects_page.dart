import 'package:flutter/material.dart';
import 'package:hirebridge/Frontend/Profile/edits/reusable_edit_widgets.dart';
import 'package:hirebridge/models/jobseeker_edit_models.dart';
import 'package:hirebridge/Frontend/LoginPages/AppColors.dart';

class EditProjectsPage extends StatefulWidget {
  final List<EditProject> initialProjects;
  const EditProjectsPage({super.key, required this.initialProjects});

  @override
  State<EditProjectsPage> createState() => _EditProjectsPageState();
}

class _EditProjectsPageState extends State<EditProjectsPage> {
  late List<EditProject> _projects;

  @override
  void initState() {
    super.initState();
    _projects = List.from(widget.initialProjects);
  }

  void _addProject() {
    setState(() {
      _projects.add(EditProject(name: 'New Project'));
    });
  }

  void _removeProject(int index) {
    setState(() {
      _projects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditPageLayout(
      title: 'Projects',
      onClose: () => Navigator.pop(context),
      onAdd: _addProject,
      onSave: () => Navigator.pop(context, _projects),
      children: _projects.isEmpty
          ? [
              EmptyStateHint(
                message: 'You haven\'t added any projects yet.\nClick the + icon or button below to start.',
                onAdd: _addProject,
              ),
            ]
          : _projects.asMap().entries.map((entry) {
              int idx = entry.key;
              EditProject project = entry.value;

              return EditCard(
                onDelete: () => _removeProject(idx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project name
                    TextFormField(
                      initialValue: project.name,
                      onChanged: (val) => project.name = val,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Project Name',
                        hintStyle: TextStyle(color: Colors.white30),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Row for Languages and Tools
                    Row(
                      children: [
                        Expanded(child: _buildTagSection('Languages', project.languages, (tag) {
                          setState(() => project.languages.add(tag));
                        })),
                        const SizedBox(width: 15),
                        Expanded(child: _buildTagSection('Tools', project.tools, (tag) {
                          setState(() => project.tools.add(tag));
                        })),
                      ],
                    ),
                    const SizedBox(height: 20),

                    EditInputField(
                      label: 'Description',
                      initialValue: project.description,
                      onChanged: (val) => project.description = val,
                    ),
                    
                    // Github link
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        initialValue: project.githubUrl,
                        onChanged: (val) => project.githubUrl = val,
                        style: const TextStyle(color: AppColors.cream, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Github :',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }

  Widget _buildTagSection(String title, List<String> tags, Function(String) onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                // Simplified: prompt for text
                _showAddTagDialog(onAdd);
              },
              child: const Icon(Icons.add_circle_outline, color: Colors.white70, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 80,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1633),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: tags.map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cream.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(t, style: const TextStyle(color: AppColors.cream, fontSize: 12)),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTagDialog(Function(String) onAdd) {
    String newTag = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3C),
        title: const Text('Add Item', style: TextStyle(color: Colors.white)),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) => newTag = val,
          decoration: const InputDecoration(hintText: 'Enter name', hintStyle: TextStyle(color: Colors.white30)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            if (newTag.isNotEmpty) onAdd(newTag);
            Navigator.pop(context);
          }, child: const Text('Add')),
        ],
      ),
    );
  }
}
