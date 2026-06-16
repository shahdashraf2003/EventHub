import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();
  static const _keySavedAccounts = 'saved_accounts';

  static Future<void> saveAccount(String name, String email, String password) async {
    final accounts = await getSavedAccounts();
    
    accounts.removeWhere((acc) => acc['email'] == email);
      accounts.insert(0, {
      'name': name,
      'email': email,
      'password': password,
    });
      await _storage.write(key: _keySavedAccounts, value: jsonEncode(accounts));
  }

  static Future<List<Map<String, String>>> getSavedAccounts() async {
    final str = await _storage.read(key: _keySavedAccounts);
    if (str != null && str.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(str);
      return decoded.map((e) => Map<String, String>.from(e)).toList();
    }
    return [];
  }

  static Future<void> removeAccount(String email) async {
    final accounts = await getSavedAccounts();
    accounts.removeWhere((acc) => acc['email'] == email);
    await _storage.write(key: _keySavedAccounts, value: jsonEncode(accounts));
  }
}
