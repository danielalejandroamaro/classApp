import 'package:lab/common/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferencesKey {
  token,
  tokenType,
}

class SharedPreferencesService {
  /// Singleton boilerplate
  static final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _sharedPreferencesService;
  }

  SharedPreferencesService._internal();
  /// Singleton boilerplate

  late SharedPreferences _prefs;
  SharedPreferences get prefs => _prefs;

  Future initialize() async => _prefs = await SharedPreferences.getInstance();

  String getToken() {
    var _token = prefs.getString(SharedPreferencesKey.token.name.toShortString);
    if(_token == null) {
      throw Exception('ESTA TALLA NOTHING DOING');
    }
    return _token!;   /// EL "!" NO ES NECESARIO POR EL IF DE ARRIBA, PERO ES LA FORMA COMO SE ASEGURA KE ESA VARIABLE TIENE VALOR
  }

  setToken(String token) {
    prefs.setString(SharedPreferencesKey.token.name.toShortString, token);
  }
}