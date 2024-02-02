import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/shared/endpoints.dart';
import 'package:dio/dio.dart';

class AuthFreeAPIService{
  final dio = Dio(BaseOptions(
      baseUrl: Endpoints.apiUrl,
      connectTimeout: const Duration(seconds: 35),
      receiveTimeout: const Duration(seconds: 15),
      headers: Endpoints.getHeader()));

  AuthFreeAPIService() {
    dio.interceptors
        .add(InterceptorsWrapper(onError: (error, handler) async {
      var response = error.response;

      if (response != null) {
        showSnackBar("Some error occurred, please try again later!");
      }
      return handler.next(error);
    }));
  }

  Future<void> increaseCount(String email)async{
    try{

      Response res = await dio.put(Endpoints.increaseCrushesCount, queryParameters: {
        'crushEmail': email
      });
      if(res.statusCode==200){
        return;
      }else{
        return Future.error(res.statusMessage.toString());
      }
    }catch(err){
      return Future.error(err.toString());
    }
  }

  Future<void> decreaseCount(String email)async{
    try{

      Response res = await dio.put(Endpoints.decreaseCrushesCount, queryParameters: {
        'crushEmail': email
      });
      if(res.statusCode==200){
        return;
      }else{
        return Future.error(res.statusMessage.toString());
      }
    }catch(err){
      return Future.error(err.toString());
    }
  }
}