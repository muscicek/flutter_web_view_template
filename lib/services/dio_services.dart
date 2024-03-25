import 'dart:io';

import 'package:dio/dio.dart';
import 'package:web_view/model/AppModel.dart';

mixin DioServices {
  final dio = Dio();
  Future<AppModel> getData() async {
    final response = await dio.get("https://mezat.inovamakademi.com/api-response");
    return AppModel.fromJson(response.data);
  }
}
