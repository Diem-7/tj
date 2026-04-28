class TradeFormFormatting {
  const TradeFormFormatting._();

  static String? dateText(DateTime? value) {
    if (value == null) return null;
    final local = value.toLocal();
    String two(int number) => number.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  static String? numberText(double? value) {
    if (value == null) return null;
    return value.toString();
  }
}
