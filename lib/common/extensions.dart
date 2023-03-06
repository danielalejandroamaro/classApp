extension StringX on String {
  int get toInt => int.parse(this);

  Uri toUri({Map<String, dynamic>? qParams}) {
    var uri = Uri.parse(this);
    if (qParams == null) {
      return uri;
    }
    return uri.replace(queryParameters: qParams);
  }

  String get toShortString => split('.').last.toLowerCase();
}
