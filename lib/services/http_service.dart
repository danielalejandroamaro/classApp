import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab/common/extensions.dart';
import 'package:lab/models/user.dart';

import '../common/constants.dart';
import 'shared_preferences_service.dart';

class HttpService {
  /// Singleton boilerplate
  static final HttpService _httpService = HttpService._internal();

  factory HttpService() {
    return _httpService;
  }

  HttpService._internal();

  /// Singleton boilerplate

  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  final http.Client client = http.Client();
  Map<String, String> headers = {};
  String? token;
  String? tokenType;
  User? me;

  Future<bool> login(
      {required String username, required String password}) async {
    String baseUrl = R.urls.urlBase;

    Uri url = '$baseUrl/token'.toUri();

    try {
      var map = <String, dynamic>{};
      map['username'] = username;
      map['password'] = password;

      http.Response response = await client.post(url, body: map);
      var data = _decodeData(response);
      _sharedPreferencesService.setToken(data['access_token']);
      return true;
    } catch (_) {
      return false;
    }

    return await Future.delayed(
      const Duration(seconds: 5),
      () => true,
    );
    // return await client.get(url);
  }

  getMe() async {
    String baseUrl = R.urls.urlBase;
    // Uri url = '$baseUrl' 'me'.toUri();
    Uri url = '${baseUrl}/me'.toUri();

    try {
      _updateHeaders();
      http.Response response = await client.get(url, headers: headers);
      var data = _decodeData(response);
      me = User.fromJson(data);
    } catch (_) {}
  }

  _updateHeaders() async {
    headers.clear();
    token = _sharedPreferencesService.getToken();
    headers.putIfAbsent('Authorization', () => 'Bearer $token');
  }

  _decodeData(http.Response response) {
    var data;
    if (response.statusCode == 200) {
      data = json.decode(utf8.decode(response.bodyBytes));
    } else {
      data = {};
    }
    return data;
  }
}
