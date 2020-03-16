import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../config/config.dart';

class DioHandler {
  static Dio _instance;

  bool withHeader;

  static Future<String> getToken() async {
    SharedPreferences _storage = await SharedPreferences.getInstance();
    String value = _storage.getString("accessToken");
    return value;
  }

  static Future<Dio> getInstance(bool withToken) async {
    if (_instance == null) {
      BaseOptions options;
      final value = await getToken();
      if (value != null) {
        options = BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 20000,
          baseUrl: "http://numbersapi.com/",
//          baseUrl: config['base_url'],
          headers: withToken
              ? {
                  "Authorization": "Bearer $value",
                  "Accept": "application/json",
                }
              : {
                  "Accept": "application/json",
                },
        );
      } else {
        options = BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 20000,
          baseUrl: "http://numbersapi.com/",
//          baseUrl: config['base_url'],
          headers: {
            "Accept": "application/json;charset=UTF-8",
            "Charset": 'utf-8'
          },
        );
      }

//      _instance.interceptors.add(InterceptorsWrapper(
//        onError: (DioError e) async {
//          showError(context, "")
//        }
//      ));

      _instance = Dio(options);
      return _instance;
    } else {
      return _instance;
    }
  }
}
