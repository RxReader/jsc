class JsonArrayUtils {
  const JsonArrayUtils._();

  static List<T> fromJsonArray<T>(List<dynamic> json, T Function(Object json) fromJsonT) {
    return json.map((dynamic element) => fromJsonT(element as Object)).toList();
  }
}
