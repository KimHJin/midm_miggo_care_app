import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _kNameKey = 'name';
  static const String _kBirthdateKey = 'birthdate';
  static const String _kHeightKey = 'height';
  static const String _kWeightKey = 'weight';
  static const String _kGenderKey = 'gender';

  static Future<UserInfo?> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString(_kNameKey);
    String? birthdate = prefs.getString(_kBirthdateKey);
    double? height = prefs.getDouble(_kHeightKey);
    double? weight = prefs.getDouble(_kWeightKey);
    String? gender = prefs.getString(_kGenderKey);

    if (name != null && birthdate != null && height != null && weight != null && gender != null) {
      return UserInfo(
        name: name,
        birthdate: birthdate,
        height: height,
        weight: weight,
        gender: gender,
      );
    }

    return null;
  }

  static Future<void> setUserInfo(UserInfo userInfo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_kNameKey, userInfo.name);
    await prefs.setString(_kBirthdateKey, userInfo.birthdate);
    await prefs.setDouble(_kHeightKey, userInfo.height);
    await prefs.setDouble(_kWeightKey, userInfo.weight);
    await prefs.setString(_kGenderKey, userInfo.gender);
  }

  static Future<void> clearUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}

class UserInfo {
  final String name;
  final String birthdate;
  final double height;
  final double weight;
  final String gender;

  UserInfo({
    required this.name,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.gender,
  });
}