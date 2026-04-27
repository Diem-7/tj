import '../../domain/instruments/instrument.dart';

class InstrumentMapper {
  static Instrument fromMap(Map<String, Object?> map) {
    return Instrument(
      id: map['id']! as String,
      symbol: map['symbol']! as String,
      name: map['name'] as String?,
      isActive: (map['is_active']! as int) == 1,
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    );
  }
}
