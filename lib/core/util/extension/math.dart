// Extension for any type T to parse to double or int
extension ParseExtensions<T> on T {
  /// Parse the value to double, defaulting to 0.0 if parsing fails
  double get pd => double.tryParse(toString()) ?? 0.0;

  /// Parse the value to int, defaulting to 0 if parsing fails
  int get pi => int.tryParse(toString()) ?? 0;
}

// Extension for List<T> to sum all elements, assuming each element can be parsed as a number
extension ListSum<T> on List<T> {
  /// Sums all elements of the list, defaulting to 0.0 if parsing fails
  double get sum {
    double total = 0;
    forEach((e) {
      total += double.tryParse(e.toString()) ?? 0.0;
    });
    return total;
  }
}

/*
void main() {
  // Example using dp and ip on a single value
  String strValue = "123.45";
  print(strValue.dp); // 123.45 (parsed as double)
  print(strValue.ip); // 123 (parsed as int)
  
  // Example using List<T> extension
  List<dynamic> numbers = ["12.34", "56.78", "9.01"];
  print(numbers.sum); // 78.13 (sum of all numbers)

  // Edge cases
  print("invalid number".dp); // 0.0 (parsing fails, defaults to 0.0)
  print("invalid number".ip); // 0 (parsing fails, defaults to 0)
}
 */