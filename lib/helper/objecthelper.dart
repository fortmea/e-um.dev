void inspectObject(Map<String, dynamic> object) {
  object.forEach((key, value) {
    print('Field: $key, Type: ${value.runtimeType}');
  });
}
