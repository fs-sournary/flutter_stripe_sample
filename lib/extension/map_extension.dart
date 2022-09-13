import 'dart:convert';

extension MapExtension on Map<String, dynamic> {
  String toPrettyString() {
    const encoder = JsonEncoder.withIndent("    ");
    return encoder.convert(this);
  }
}
