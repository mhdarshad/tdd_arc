// Extension to check if the dynamic value is a valid number
extension IsNumeric on dynamic {
  // Check if the value can be parsed as a number (integer or double)
  bool get isNumeric => double.tryParse(toString()) != null;
}

// Extension to safely convert dynamic value to null if it represents the string "null"
extension NullSafeValue on dynamic {
  // If the value is a string 'null' or null itself, return null; otherwise return the original value.
  dynamic get nullSafeValue => (this == null || toString() == 'null') ? null : this;
}

extension UrlValidation on Uri {
  // Extension method to validate and fix a URL
  Uri get fixUrl {
    // Ensure that we don't have double slashes in the path (except after the domain)
    final fixedPath = path.replaceAll(RegExp(r'//'), '/');
    
    // Rebuild the Uri with the corrected path
    return replace(path: fixedPath);
  }
}



/*
void main() {
  var value1 = "123.45";
  var value2 = "Not a number";
  var value3 = "null";
  var value4 = null;

  // Check if value1 is numeric
  print(value1.isNumeric); // true

  // Check if value2 is numeric
  print(value2.isNumeric); // false

  // Safely convert value3 to null
  print(value3.nullSafeValue); // null

  // Safely convert value4 to null
  print(value4.nullSafeValue); // null

  // Safely convert a valid value
  var validValue = 42;
  print(validValue.nullSafeValue); // 42
}
  */