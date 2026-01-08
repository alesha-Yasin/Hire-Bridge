class EditSkill {
  String name;
  String projectName;
  String workWith;

  EditSkill({
    required this.name,
    this.projectName = '',
    this.workWith = '',
  });
}

class EditProject {
  String name;
  List<String> languages;
  List<String> tools;
  String description;
  String githubUrl;

  EditProject({
    required this.name,
    List<String>? languages,
    List<String>? tools,
    this.description = '',
    this.githubUrl = '',
  })  : languages = languages != null ? List.from(languages) : [],
        tools = tools != null ? List.from(tools) : [];
}

class EditEducation {
  String degree;
  String institution;
  String year;
  String grade;

  EditEducation({
    required this.degree,
    required this.institution,
    required this.year,
    this.grade = '',
  });
}

class EditExperience {
  String company;
  String role;
  String period;
  String description;

  EditExperience({
    required this.company,
    required this.role,
    this.period = '',
    this.description = '',
  });
}
