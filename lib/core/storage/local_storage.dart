abstract class LocalStorage {
  dynamic read(String key);
  void write(String key, dynamic value);
  void delete(String key);
  void deleteAll(List<String> keys);
  dynamic readSecure(String key);
  void writeSecure(String key, dynamic value);
  Future writeSecureAsync(String key, dynamic value);
  void deleteSecure(String key);
  Future deleteSecureAsync(String key);
  void deleteAllSecure();
}
