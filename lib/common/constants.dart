class R {
  R._();

  static RUrl get urls => const RUrl._();
}

class RUrl {
  const RUrl._();
  final String urlBase = 'http://10.50.0.3:8000';
  final String wsUrlBase = 'ws://10.50.0.3:8000';
}