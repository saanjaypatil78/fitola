/// Utility functions for model comparison and validation
library;

/// Compares two lists for equality, handling null values
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Compares two maps for equality, handling null values
bool mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}

/// Safely parses a DateTime from dynamic value
/// Returns null if parsing fails for optional fields
DateTime? parseDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  try {
    return DateTime.parse(value.toString());
  } catch (e) {
    return null;
  }
}

/// Safely parses a required DateTime, falling back to now if parsing fails
DateTime parseDateTimeRequired(dynamic value) {
  if (value is DateTime) return value;
  try {
    return DateTime.parse(value.toString());
  } catch (e) {
    return DateTime.now();
  }
}
