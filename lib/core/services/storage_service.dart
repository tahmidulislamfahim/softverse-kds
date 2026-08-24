import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _idKey = 'userId';
  static const String _nameKey = 'fullName';
  static const String _emailKey = 'email';
  static const String _themeModeKey = 'themeMode';
  static const String _mainStationUrlKey = 'mainStationUrl';
  static const String _notificationSoundEnabledKey = 'notificationSoundEnabled';
  static const String _orderReceivedSoundKey = 'orderReceivedSound';
  static const String _orderPaidSoundKey = 'orderPaidSound';
  static const String _orderClearedSoundKey = 'orderClearedSound';
  static const String _warningColorSecondsKey = 'warningColorSeconds';
  static const String _dangerColorSecondsKey = 'dangerColorSeconds';

  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool hasToken() => _preferences?.getString(_accessTokenKey) != null;

  static String? get accessToken => _preferences?.getString(_accessTokenKey);
  static String? get refreshToken => _preferences?.getString(_refreshTokenKey);
  static String? get userId => _preferences?.getString(_idKey);
  static String? get fullName => _preferences?.getString(_nameKey);
  static String? get email => _preferences?.getString(_emailKey);

  static Future<void> saveUserSession({
    required String id,
    required String fullName,
    required String email,
    required String accessToken,
    required String refreshToken,
  }) async {
    await _preferences?.setString(_idKey, id);
    await _preferences?.setString(_nameKey, fullName);
    await _preferences?.setString(_emailKey, email);
    await _preferences?.setString(_accessTokenKey, accessToken);
    await _preferences?.setString(_refreshTokenKey, refreshToken);
  }

  static Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _preferences?.setString(_accessTokenKey, accessToken);
    await _preferences?.setString(_refreshTokenKey, refreshToken);
  }

  static Future<void> logoutUser() async {
    await _preferences?.remove(_accessTokenKey);
    await _preferences?.remove(_refreshTokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_nameKey);
    await _preferences?.remove(_emailKey);
  }

  static String get themeMode =>
      _preferences?.getString(_themeModeKey) ?? 'system';

  static Future<void> setThemeMode(String mode) async {
    await _preferences?.setString(_themeModeKey, mode);
  }

  static String? get mainStationUrl =>
      _preferences?.getString(_mainStationUrlKey);

  static Future<void> setMainStationUrl(String url) async {
    await _preferences?.setString(_mainStationUrlKey, url);
  }

  static bool get notificationSoundEnabled =>
      _preferences?.getBool(_notificationSoundEnabledKey) ?? true;

  static Future<void> setNotificationSoundEnabled(bool value) async {
    await _preferences?.setBool(_notificationSoundEnabledKey, value);
  }

  static String get orderReceivedSoundId =>
      _preferences?.getString(_orderReceivedSoundKey) ?? 'order_received';

  static Future<void> setOrderReceivedSoundId(String id) async {
    await _preferences?.setString(_orderReceivedSoundKey, id);
  }

  static String get orderPaidSoundId =>
      _preferences?.getString(_orderPaidSoundKey) ?? 'order_paid';

  static Future<void> setOrderPaidSoundId(String id) async {
    await _preferences?.setString(_orderPaidSoundKey, id);
  }

  static String get orderClearedSoundId =>
      _preferences?.getString(_orderClearedSoundKey) ?? 'clear';

  static Future<void> setOrderClearedSoundId(String id) async {
    await _preferences?.setString(_orderClearedSoundKey, id);
  }

  static int get warningColorSeconds =>
      _preferences?.getInt(_warningColorSecondsKey) ?? 180;

  static Future<void> setWarningColorSeconds(int seconds) async {
    await _preferences?.setInt(_warningColorSecondsKey, seconds);
  }

  static int get dangerColorSeconds =>
      _preferences?.getInt(_dangerColorSecondsKey) ?? 300;

  static Future<void> setDangerColorSeconds(int seconds) async {
    await _preferences?.setInt(_dangerColorSecondsKey, seconds);
  }
}
