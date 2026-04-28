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

  static Map<String, Object?> toInsertMap(Instrument instrument) {
    return {
      'id': instrument.id,
      'symbol': instrument.symbol,
      'name': instrument.name,
      'is_active': instrument.isActive ? 1 : 0,
      'created_at': instrument.createdAt.toIso8601String(),
      'updated_at': instrument.updatedAt.toIso8601String(),
    };
  }
}
