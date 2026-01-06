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
    this.languages = const [],
    this.tools = const [],
    this.description = '',
    this.githubUrl = '',
  });
}

class EditEducation {
  String degree;
  String institution;
  String year;

  EditEducation({
    required this.degree,
    required this.institution,
    required this.year,
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
