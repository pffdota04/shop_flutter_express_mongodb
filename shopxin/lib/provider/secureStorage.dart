import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStroage {
  final storage = FlutterSecureStorage();

  Future writeSecureStorage(String key, String value) async {
    var writeData = await storage.write(key: key, value: value);
    return writeData;
  }

  Future<Map<String, String>> realStorage() async {
    var data = await storage.readAll();
    return data;
  }

  Future deleteStorage() async {
    await storage.deleteAll();
    return;
  }
}
