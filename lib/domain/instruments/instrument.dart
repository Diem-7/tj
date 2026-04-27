class Instrument {
  const Instrument({
    required this.id,
    required this.symbol,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String symbol;
  final String? name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
}
