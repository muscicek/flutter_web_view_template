import 'package:dio/dio.dart';
import 'package:web_view/constants/AppConstants.dart';
import 'package:web_view/model/AppModel.dart';

mixin DioServices {
  final dio = Dio();
  Future<AppModel> getData() async {
    final response = await dio.get(AppConstants.API_URL);
    return AppModel.fromJson(response.data);
  }
}
