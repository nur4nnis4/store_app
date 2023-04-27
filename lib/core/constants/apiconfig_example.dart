/// TODO : Change code below to your server base url and
///change apiconfig_example.dart to .apiconfig.dart

const _baseUrl = 'http://127.0.0.1:8080/store-app-api/public_html/api';

const _storageUrl = 'http://127.0.0.1:8080/store-app-api/storage/app/public';

String get baseUrl {
  return _baseUrl;
}

String get storageUrl {
  return _storageUrl;
}
