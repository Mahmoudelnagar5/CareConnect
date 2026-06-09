import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isCompleted();
  Future<void> setCompleted();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._prefs);
  final SharedPreferences _prefs;

  static const _key = 'cc_onboarding_done';

  @override
  Future<bool> isCompleted() async => _prefs.getBool(_key) ?? false;

  @override
  Future<void> setCompleted() async => _prefs.setBool(_key, true);
}
