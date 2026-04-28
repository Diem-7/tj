class TradeCreateParsing {
  const TradeCreateParsing._();

  static String dateTimeText() {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${now.year}-${two(now.month)}-${two(now.day)} '
        '${two(now.hour)}:${two(now.minute)}';
  }

  static DateTime requiredDate(String value, String label) {
    final parsed = DateTime.tryParse(value.trim().replaceFirst(' ', 'T'));
    if (parsed == null) {
      throw FormatException('$label ist ungueltig.');
    }
    return parsed.toUtc();
  }

  static double requiredDouble(String value, String label) {
    final parsed = double.tryParse(value.trim());
    if (parsed == null) {
      throw FormatException('$label ist erforderlich.');
    }
    return parsed;
  }

  static double? optionalDouble(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return double.tryParse(trimmed) ??
        (throw const FormatException('Eine optionale Zahl ist ungueltig.'));
  }

  static int? optionalInt(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed) ??
        (throw const FormatException('Das Rating ist ungueltig.'));
  }
}
