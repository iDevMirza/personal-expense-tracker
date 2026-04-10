class LocalStorageService {
  LocalStorageService._internal();

  static final LocalStorageService _instance = LocalStorageService._internal();

  factory LocalStorageService(){
    return _instance;
  }
}