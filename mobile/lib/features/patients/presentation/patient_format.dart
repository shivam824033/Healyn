// Small presentation helpers shared by the patient screens. Pure functions,
// no PHI logging.

/// Up to two uppercase initials from a name, for avatars. Returns '?' if empty.
String patientInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  if (parts.isEmpty) return '?';
  return parts.take(2).map((p) => p[0].toUpperCase()).join();
}

/// Whole years between [dob] and today.
int patientAgeInYears(DateTime dob) {
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age;
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// A date-of-birth as `21 May 1990`.
String formatBirthDate(DateTime d) =>
    '${d.day} ${_months[d.month - 1]} ${d.year}';
