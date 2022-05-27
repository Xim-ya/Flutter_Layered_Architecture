import 'package:json_annotation/json_annotation.dart';

class IntConverter implements JsonConverter<int?, Object?> {
  const IntConverter();

  @override
  int? fromJson(Object? object) {
    if (object == null) return null;
    if (object is num) return object.toInt();
    return int.tryParse(object.toString());
  }

  @override
  Object? toJson(int? object) => object;
}
