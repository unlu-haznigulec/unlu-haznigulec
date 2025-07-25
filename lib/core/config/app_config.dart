enum Flavor { dev, qa, prod }

class AppConfig {
  static late AppConfig instance;
  final Flavor _flavor;
  final String _name;
  final String _contractUrl;
  final String _baseUrl;
  final String _usBaseUrl;
  final String _usWssUrl;
  final String _matriksUrl;
  final String _cdnKey;
  final String _certificate;
  final String _memberKvkk;

  factory AppConfig({
    required Flavor flavor,
    required String name,
    required String contractUrl,
    required String baseUrl,
    required String usBaseUrl,
    required String usWssUrl,
    required String matriksUrl,
    required String cdnKey,
    required String certificate,
    required String memberKvkk,
  }) {
    instance = AppConfig._internal(
      flavor,
      name,
      contractUrl,
      baseUrl,
      usBaseUrl,
      usWssUrl,
      matriksUrl,
      cdnKey,
      certificate,
      memberKvkk,
    );
    return instance;
  }

  AppConfig._internal(
    this._flavor,
    this._name,
    this._contractUrl,
    this._baseUrl,
    this._usBaseUrl,
    this._usWssUrl,
    this._matriksUrl,
    this._cdnKey,
    this._certificate,
    this._memberKvkk,
  );

  bool get isProd => _flavor == Flavor.prod;

  bool get isQa => _flavor == Flavor.qa;

  bool get isDev => _flavor == Flavor.dev;

  String get name => _name;

  Flavor get flavor => _flavor;

  String get contractUrl => _contractUrl;

  String get baseUrl => _baseUrl;

  String get usBaseUrl => _usBaseUrl;

  String get usWssUrl => _usWssUrl;

  String get matriksUrl => _matriksUrl;

  String get cdnKey => _cdnKey;

  String get certificate => _certificate;

  String get memberKvkk => _memberKvkk;
}
