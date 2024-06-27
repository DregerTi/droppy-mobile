 import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class LocalHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }

  Future<Dio> withAuthInterceptor() async {
    final dio = Dio();

    final dataPath = (await getTemporaryDirectory()).path;
    final options = CacheOptions(
      // A default store is required for interceptor.
      store: HiveCacheStore(
        '$dataPath${Platform.pathSeparator}HiveCacheStore',
        hiveBoxName: 'HiveCacheStore',
      ),
      //store: MemCacheStore(),

      // All subsequent fields are optional.

      // Default.
      policy: CachePolicy.request,
      // Returns a cached response on error but for statuses 401 & 403.
      // Also allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to [null].
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to [null].
      maxStale: const Duration(days: 7),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.high,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended when [true].
      allowPostMethod: false,
    );


    dio.interceptors
      ..add(DioCacheInterceptor(options: options))
      ..add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? jwt = prefs.getString('jwtToken');
          if(jwt != null){
            options.headers['Authorization'] = 'Bearer $jwt';
          }
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            final String? refreshToken = prefs.getString('refreshToken');
            if (refreshToken != null) {
              final dio = Dio();
              final response = await dio.post(
                '$baseUrl/token/refresh',
                data: {
                  'refresh_token': refreshToken,
                },
              );
              if (response.statusCode == 200) {
                final Map<String, dynamic> data = response.data;
                await prefs.setString('jwtToken', data['token']);
                await prefs.setString('refreshToken', data['refresh_token']);
                options.store?.clean();
                e.requestOptions.headers['Authorization'] = 'Bearer ${data['token']}';
                return handler.resolve(await dio.fetch(e.requestOptions));
              }
            }
          }
          return handler.next(e);
        },
      ),
    );

    return dio;
  }

}