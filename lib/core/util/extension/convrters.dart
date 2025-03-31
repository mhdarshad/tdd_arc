import 'package:intl/intl.dart';

/// Extension to parse values into int or double from dynamic input
extension ParseToNumber on dynamic {
  /// Converts to int if possible, otherwise returns null
  int? get parseInt => int.tryParse(toString());

  /// Converts to double if possible, otherwise returns null
  double? get parseDouble => double.tryParse(toString());
}

/// Returns the current date and time as a string
String get dateTimeNowString => DateTime.now().toString();

/// Extension on String for DateTime parsing and formatting
extension StringDateTime on String {
  /// Converts the string to DateTime, returns null if the format is invalid
  DateTime? get toDateTime => DateTime.tryParse(this);

  /// Converts the string to a local DateTime, returns null if the format is invalid
  DateTime? get toLocalDateTime => DateTime.tryParse(this)?.toLocal();

  /// Returns the DateTime as a string in server-friendly format
  String? get toServerDateTimeString => toLocalDateTime?.toString();

  /// Converts the string to a DateTime and returns a formatted string (DD-MM-YY HH:mm a)
  String get toDDMMYYHMAFormat {
    final localDate = toLocalDateTime;
    if (localDate != null) {
      return DateFormat('yyyy-MM-dd hh:mm a').format(localDate);
    } else {
      return ''; // Return an empty string if the DateTime is null
    }
  }

  ///EEE. d, H:mm
  String get toWeekDateTImeFormat {
    final localDate = toLocalDateTime;
    if (localDate != null) {
      return DateFormat("EEE. d, H:mm").format(localDate);
    } else {
      return ''; // Return an empty string if the DateTime is null
    }

  }
  String get formatMonthYear {
    final localDate = toLocalDateTime;
    if (localDate != null) {
      return DateFormat("MMMM yyyy").format(localDate);
    } else {
      return ''; // Return an empty string if the DateTime is null
    }
  }
  String get formatWeekday {
    final localDate = toLocalDateTime;
    if (localDate != null) {
      return DateFormat("EEEE").format(localDate);
    } else {
      return ''; // Return an empty string if the DateTime is null
    }
  }
}

/*
void main() {

  // Example String to DateTime Conversion
  String dateStr = "2025-02-23T12:30:00Z";
  print(dateStr.toDateTime); // Prints: 2025-02-23 12:30:00.000Z
  print(dateStr.toLocalDateTime); // Prints: 2025-02-23 07:30:00.000 (depends on your local timezone)
  print(dateStr.toServerDateTimeString); // Prints: 2025-02-23 07:30:00.000
  print(dateStr.toDDMMYYHMAFormat); // Prints: 2025-02-23 12:30 PM

  // Example Number Parsing
  var numString = "123.45";
  print(numString.parseInt); // null (not an integer)
  print(numString.parseDouble); // 123.45

  // Example DateTime Now String
  print(dateTimeNowString); // Prints current date-time as string
}
 */