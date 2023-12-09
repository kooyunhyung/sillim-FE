import 'dart:math';

class APIConfig {
  final String host;
  final int version;

  APIConfig(this.host, {required this.version});
}

final host = APIConfig('https://9091-122-45-204-107.ngrok-free.app', version: 1);     // 8080 port
final host2 = APIConfig('https://82f0-122-45-204-107.ngrok-free.app', version: 1);    // 9200 port


String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  var query = '';

  params.forEach((key, value) {
    if (inRecursion) {
      key = '[$key]';
    }

    if (value is String || value is int || value is double || value is bool) {
      query += '$prefix$key=${Uri.encodeQueryComponent(value.toString())}';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });

  return query;
}

String createUri(String path, Map<String, dynamic> param) {
  final params = param != null ? getQueryString(param) : '';

  //이 부분도 필요하시다면 변경하시고 사용하시면 됩니다.
  if (path.substring(0,4)=='sill' || path.substring(0,4)=='apis'){
    print('${host.host}/$path?${params.substring(min(params.length, 1))}');
    return '${host.host}/$path?${params.substring(min(params.length, 1))}';
  }

  print('${host2.host}/$path?${params.substring(min(params.length, 1))}');
  return '${host2.host}/$path?${params.substring(min(params.length, 1))}';
}
