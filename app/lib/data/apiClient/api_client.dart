import 'dart:async';

import 'package:app/data/apiClient/requestMemoryManager.dart';
import 'package:app/data/models/newPassword/post_newPassword_req.dart';
import 'package:app/data/models/newPassword/post_newPassword_resp.dart';
import 'package:app/core/app_export.dart';
import 'package:app/data/prefs/multi_account_management.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:get/get_connect/http/src/exceptions/exceptions.dart';

class ApiClient {
  var url = Get.find<EnvConfig>().config.baseUrl;
  var config = Get.find<EnvConfig>().config;
  var dio = Dio.Dio();

  ///method can be used for checking internet connection
  ///returns [bool] based on availability of internet
  Future isNetworkConnected() async {
    if (!await Get.find<NetworkInfo>().isConnected()) {
      throw NoInternetException('No Internet Found!');
    }
  }

  /// is `true` when the response status code is between 200 and 299
  ///
  /// user can modify this method with custom logics based on their API response
  bool _isSuccessCall(Dio.Response response) {
    return response.statusCode! >= 200 && response.statusCode! < 300;
  }

  Future<T> genericPost<T>(Map<String, String> headers, dynamic requestData,
      T fromJson(Map<String, dynamic> json), String urlpath,
      {Map<String, dynamic>? query = null}) async {
    try {
      await isNetworkConnected();
      Dio.Response response = await dio.post(urlpath,
          options: Dio.Options(headers: headers),
          data: requestData,
          queryParameters: query);
      if (_isSuccessCall(response)) {
        return fromJson(response.data);
      }
      throw Dio.DioException.badResponse(
          statusCode: response.statusCode!,
          requestOptions: response.requestOptions,
          response: response);
    } catch (error) {
      if (error is Dio.DioException) {
        if (error.response!.statusCode == 400) {
          return fromJson(error.response!.data);
        }
        if (error.response!.statusCode == 401) {
          throw UnauthorizedException();
        } else if (error.response!.statusCode == 404) {
          throw ServerException();
        } else if (error.response!.statusCode! >= 500) {
          throw ServerException();
        } else {
          throw NoInternetException();
        }
      }
      rethrow;
    }
  }

  Future<T> genericPatch<T>(
    Map<String, String> headers,
    dynamic requestData,
    T fromJson(Map<String, dynamic> json),
    String urlpath,
  ) async {
    try {
      await isNetworkConnected();
      Dio.Response response = await dio.patch(
        urlpath,
        options: Dio.Options(headers: headers),
        data: requestData,
      );
      // Response response = await httpClient.patch(urlpath,
      //     headers: headers, data: requestData, contentType: 'application/json');
      if (_isSuccessCall(response)) {
        return fromJson(response.data);
      }
      throw Dio.DioException.badResponse(
          statusCode: response.statusCode!,
          requestOptions: response.requestOptions,
          response: response);
    } catch (error, stackTrace) {
      Logger.log(error, stackTrace: stackTrace);
      if (error is Dio.DioException) {
        if (error.response!.statusCode == 401) {
          throw UnauthorizedException();
        } else if (error.response!.statusCode == 404) {
          throw ServerException();
        } else if (error.response!.statusCode! >= 500) {
          throw ServerException();
        } else {
          throw NoInternetException();
        }
      }
      rethrow;
    }
  }

  Future<List<T>> genericList<T>(
      Map<String, String> headers,
      Map<String, dynamic>? query,
      T fromJson(Map<String, dynamic> json),
      String urlpath) async {
    try {
      await isNetworkConnected();
      Dio.Response response = await dio.get(urlpath,
          options: Dio.Options(headers: headers), queryParameters: query);
      if (_isSuccessCall(response)) {
        List<T> list = [];
        for (var wall in response.data) {
          list.add(fromJson(wall));
        }
        return list;
      }
      throw Dio.DioException.badResponse(
          statusCode: response.statusCode!,
          requestOptions: response.requestOptions,
          response: response);
    } catch (error) {
      //check if error is of type NoInternetException or SocketException
      if (error is Dio.DioException) {
        if (error.response!.statusCode == 401 ||
            error.response!.statusCode == 403) {
          Get.find<MultiAccountManagement>().removeAccount();
          RequestMemoryManager.instance.clearData();
          Get.offAllNamed(GeneralAppRoutes.WelcomeScreenRoute);
          Get.showSnackbar(GetSnackBar(
            message: "Vous avez été déconnecté, veuillez vous reconnecter",
            duration: 3.seconds,
            snackPosition: SnackPosition.TOP,
          ));
          throw Exception('Vous avez été déconnecté');
        } else if (error.response!.statusCode == 404) {
          throw ServerException();
        } else if (error.response!.statusCode! >= 500) {
          throw ServerException();
        } else {
          throw NoInternetException();
        }
      }
      rethrow;
    }
  }

  Future<T> genericGet<T>(
      Map<String, String> headers,
      Map<String, dynamic>? query,
      T fromJson(Map<String, dynamic> json),
      String urlpath) async {
    try {
      await isNetworkConnected();
      Dio.Response response = await dio.get(urlpath,
          options: Dio.Options(headers: headers), queryParameters: query);
      if (_isSuccessCall(response)) {
        return fromJson(response.data);
      }
      throw Dio.DioException.badResponse(
          statusCode: response.statusCode!,
          requestOptions: response.requestOptions,
          response: response);
    } catch (error, stackTrace) {
      Logger.log(error, stackTrace: stackTrace);
      if (error is Dio.DioException) {
        if (error.response!.statusCode == 401 ||
            error.response!.statusCode == 403) {
          Get.find<MultiAccountManagement>().removeAccount();
          RequestMemoryManager.instance.clearData();
          Get.offAllNamed(GeneralAppRoutes.WelcomeScreenRoute);
          Get.showSnackbar(GetSnackBar(
            message: "Vous avez été déconnecté, veuillez vous reconnecter",
            duration: 3.seconds,
            snackPosition: SnackPosition.TOP,
          ));
          throw Exception('Vous avez été déconnecté');
        } else if (error.response!.statusCode == 404) {
          throw ServerException();
        } else if (error.response!.statusCode! >= 500) {
          throw ServerException();
        } else {
          throw NoInternetException();
        }
      }
      rethrow;
    }
  }

  Future<void> genericDelete<T>(
    Map<String, String> headers,
    Map<String, dynamic> query,
    String urlpath,
  ) async {
    try {
      await isNetworkConnected();
      Dio.Response response = await dio.delete(urlpath,
          options: Dio.Options(headers: headers), queryParameters: query);
      if (_isSuccessCall(response)) {
        return;
      }
      throw Dio.DioException.badResponse(
          statusCode: response.statusCode!,
          requestOptions: response.requestOptions,
          response: response);
    } catch (error, stackTrace) {
      Logger.log(error, stackTrace: stackTrace);
      if (error is Dio.DioException) {
        if (error.response!.statusCode == 401) {
          throw UnauthorizedException();
        } else if (error.response!.statusCode == 404) {
          throw ServerException();
        } else if (error.response!.statusCode! >= 500) {
          throw ServerException();
        } else {
          throw NoInternetException();
        }
      }
      rethrow;
    }
  }

  Future<PostNewPasswordResp> newPassword(
      PostNewPasswordReq postNewPasswordReq) async {
    try {
      await isNetworkConnected();
      Dio.Response response = await dio.post('$url/reset-password/confirm/',
          data: postNewPasswordReq.toJson());

      if (_isSuccessCall(response)) {
        return PostNewPasswordResp.fromJson(response.data);
      } else {
        throw response.data != null
            ? PostNewPasswordResp.fromJson(response.data)
            : 'Something Went Wrong!';
      }
    } catch (error, stackTrace) {
      Logger.log(error, stackTrace: stackTrace);
      if (error is Dio.DioException) {
        if (error.response!.statusCode == 400) {
          throw error.message != null
              ? PostNewPasswordResp.fromJson(error.response!.data)
              : 'Something Went Wrong!';
        }
        if (error.response!.statusCode == 401) {
          throw UnauthorizedException();
        } else if (error.response!.statusCode == 404) {
          throw ServerException();
        } else if (error.response!.statusCode! >= 500) {
          throw ServerException();
        } else {
          throw NoInternetException();
        }
      }
      rethrow;
    }
  }
}
