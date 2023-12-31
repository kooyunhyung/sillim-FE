import 'dart:math';

class APIConfig {
  final String host;
  final int version;

  APIConfig(this.host, {required this.version});
}

final host = APIConfig('https://0919-122-45-204-107.ngrok-free.app', version: 1);     // 8080 port
final host2 = APIConfig('https://28ae-122-45-204-107.ngrok-free.app', version: 1);    // 9200 port


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

  // 8080 port 통해 RDBMS와 통신을 맺어야 하는 경우
  if (path.substring(0,4)=='sill' || path.substring(0,4)=='apis'){
    //print('${host.host}/$path?${params.substring(min(params.length, 1))}');
    return '${host.host}/$path?${params.substring(min(params.length, 1))}';
  }

  // 9200 port 통해 Elastic Search와 통신을 맺어야 하는 경우
  //print('${host2.host}/$path?${params.substring(min(params.length, 1))}');
  return '${host2.host}/$path?${params.substring(min(params.length, 1))}';
}
