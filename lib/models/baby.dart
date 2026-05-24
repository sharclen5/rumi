class Baby {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String gender;
  final double weight;
  final double height;
  final DateTime dateOfBirth;

  Baby({
    required this.id,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.gender,
    required this.weight,
    required this.height,
    required this.dateOfBirth,
  });

  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - dateOfBirth.year) * 12 +
        (now.month - dateOfBirth.month);
    if (now.day < dateOfBirth.day) months--;
    return months.clamp(0, 999);
  }
}