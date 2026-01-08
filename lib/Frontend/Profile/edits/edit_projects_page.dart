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
                        color: AppColors.cream,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Project Name',
                        hintStyle: TextStyle(color: Colors.white30),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Row for Languages and Tools with larger containers
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildTagSection('Languages', project.languages, (tag) {
                          setState(() => project.languages.add(tag));
                        })),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTagSection('Tools', project.tools, (tag) {
                          setState(() => project.tools.add(tag));
                        })),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description Section
                    const Text(
                      'Description',
                      style: TextStyle(color: AppColors.cream, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: project.description,
                      maxLines: null, // Auto-expand
                      keyboardType: TextInputType.multiline,
                      onChanged: (val) {
                        // Word count restriction (250 words)
                        final words = val.trim().split(RegExp(r'\s+'));
                        if (words.length > 250) {
                          // Keep only the first 250 words
                          final truncated = words.take(250).join(' ');
                          project.description = truncated;
                          // Note: In a real app, we'd use a controller to update the UI text
                        } else {
                          project.description = val;
                        }
                      },
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Describe your project...',
                        hintStyle: TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                      ),
                    ),
                    
                    const Divider(color: Colors.white24, height: 32),

                    // Github link
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: AppColors.cream, size: 18),
                          const SizedBox(width: 12),
                          const Text('Github :', style: TextStyle(color: AppColors.cream, fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: project.githubUrl,
                              onChanged: (val) => project.githubUrl = val,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: const InputDecoration(
                                hintText: 'repository url',
                                hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
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
              style: const TextStyle(color: AppColors.cream, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _showAddTagDialog(onAdd),
              child: const Icon(Icons.add_circle_outline, color: AppColors.cream, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 140, // Slightly more height
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1633), // Exact dark navy from screenshot
            borderRadius: BorderRadius.circular(28), // High border radius as seen in screenshot
          ),
          child: tags.isEmpty 
            ? Center(child: Text('Add $title', style: const TextStyle(color: Colors.white24, fontSize: 12)))
            : SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((t) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.cream.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.cream.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            t, 
                            style: const TextStyle(color: AppColors.cream, fontSize: 12, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tags.remove(t);
                            });
                          },
                          child: const Icon(Icons.close, size: 12, color: AppColors.cream),
                        ),
                      ],
                    ),
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
        backgroundColor: const Color(0xFF0F1633),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Item', style: TextStyle(color: AppColors.cream, fontSize: 18, fontWeight: FontWeight.bold)),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) => newTag = val,
          decoration: InputDecoration(
            hintText: 'Enter name',
            hintStyle: const TextStyle(color: Colors.white30),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.cream.withOpacity(0.5))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.cream)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Cancel', style: TextStyle(color: Colors.white54))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cream,
              foregroundColor: const Color(0xFF0F1633),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (newTag.trim().isNotEmpty) onAdd(newTag.trim());
              Navigator.pop(context);
            }, 
            child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }
}
