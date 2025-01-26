import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();

  late bool _isLoggedIn;
  late String _phoneNumber;

  UserPreferences._internal();

  static UserPreferences get instance => _instance;

  // Call this method during app initialization
  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _phoneNumber = prefs.getString('phoneNumber') ?? '';
  }

  // Synchronous getters
  bool get isLoggedIn => _isLoggedIn;

  String get phoneNumber => _phoneNumber;

  // Save login details
  Future<void> saveLogin(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('phoneNumber', phoneNumber);

    // Update the cached values
    _isLoggedIn = true;
    _phoneNumber = phoneNumber;
  }
}
