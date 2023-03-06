import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab/common/extensions.dart';
import 'package:lab/models/user.dart';

import '../common/constants.dart';
import 'shared_preferences_service.dart';

class HttpService {
  String get token => _sharedPreferencesService.getToken();

  /// Singleton boilerplate
  static final HttpService _httpService = HttpService._internal();

  HttpService._internal();

  factory HttpService() {
    return _httpService;
  }
  /// Singleton boilerplate

  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  final http.Client client = http.Client();
  Map<String, String> headers = {};
  String? tokenType;
  User? me;

  logout() {
    _sharedPreferencesService.removeToken();
  }

  Future<bool> login(
      {required String username, required String password}) async {
    try {
      var map = <String, dynamic>{};
      map['username'] = username;
      map['password'] = password;

      http.Response response =
          await client.post('${R.urls.urlBase}/token'.toUri(), body: map);
      var data = _decodeData(response);
      _sharedPreferencesService.setToken(data['access_token']);
      return true;
    } catch (_) {
      return false;
    }

    // return await Future.delayed(
    //   const Duration(seconds: 5),
    //   () => true,
    // );
    // return await client.get(url);
  }

  Future getMe() async {
    // Uri url = '$baseUrl' 'me'.toUri();
    Uri url = '${R.urls.urlBase}/me'.toUri();

    _updateHeaders();
    http.Response response = await client.get(url, headers: headers);
    var data = _decodeData(response);
    me = User.fromJson(data);
  }

  _updateHeaders() async {
    headers.clear();
    headers.putIfAbsent('Authorization', () => 'Bearer $token');
  }

  _decodeData(http.Response response) {
    Map data;
    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
    } else {
      data = {};
    }
    return data;
  }
}
