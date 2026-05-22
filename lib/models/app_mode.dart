enum AppMode {
  general('general'),
  student('student');

  const AppMode(this.value);
  final String value;
}

AppMode parseAppMode(String? value) {
  return AppMode.values.firstWhere(
    (mode) => mode.value == value,
    orElse: () => AppMode.general,
  );
}
