import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveEmailAndPassword(String? email, String? password) async {
    await _storage.write(key: 'email', value: email ?? '');
    await _storage.write(key: 'password', value: password ?? '');
  }

  Future<void> saveEmailOnly(String? email) async {
    await _storage.write(key: 'email', value: email ?? '');
  }

  Future<void> clearEmailAndPassword() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: 'email');
  }

  Future<String?> getPassword() async {
    return await _storage.read(key: 'password');
  }
}
