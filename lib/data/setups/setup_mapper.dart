import '../../domain/setups/setup.dart';

class SetupMapper {
  static Setup fromMap(Map<String, Object?> map) {
    return Setup(
      id: map['id']! as String,
      name: map['name']! as String,
      isActive: (map['is_active']! as int) == 1,
      createdAt: DateTime.parse(map['created_at']! as String),
      updatedAt: DateTime.parse(map['updated_at']! as String),
    );
  }
}
