import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

/// Persists the session (token + user) locally for session persistence.
abstract class AuthLocalDataSource {
  Future<void> cacheSession({required String token, required UserModel user});
  Future<UserModel?> getCachedUser();
  Future<String?> getToken();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _kToken = 'cc_token';
  static const _kUser = 'cc_user';

  @override
  Future<void> cacheSession({
    required String token,
    required UserModel user,
  }) async {
    await _prefs.setString(_kToken, token);
    await _prefs.setString(_kUser, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final raw = _prefs.getString(_kUser);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<String?> getToken() async => _prefs.getString(_kToken);

  @override
  Future<void> clear() async {
    await _prefs.remove(_kToken);
    await _prefs.remove(_kUser);
  }
}
