void main() {
  Map<String, dynamic> map = {'a': 'b'};
  print(map.runtimeType);
  try {
    map['c'] = 123;
    print("Success");
  } catch (e) {
    print("Error: $e");
  }
}
