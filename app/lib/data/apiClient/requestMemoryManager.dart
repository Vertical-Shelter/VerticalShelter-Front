import 'package:flutter/foundation.dart';
import 'package:app/core/app_export.dart';

/// Used to store the response and the time of the api call
class RequestResponse {
  Response _data;
  DateTime _date;

  RequestResponse(this._data) : _date = DateTime.now();
}

/// Used to store the request url and query parameters
class Request {
  String url;
  Map<String, dynamic>? queryParameters;

  Request(this.url, this.queryParameters);

  @override
  bool operator ==(Object other) {
    return other is Request &&
        url == other.url &&
        mapEquals(queryParameters, other.queryParameters);
  }

  @override
  int get hashCode => url.hashCode;
}

/// Used to store the response of the api call in memory
/// so that the same api call is not made again and again
/// and the data is fetched from the memory
class RequestMemoryManager {
  Map<Request, RequestResponse> _data = {};
  static RequestMemoryManager? _instance;
  static int _requestObsolecence = 20;

  static RequestMemoryManager get instance {
    _instance ??= RequestMemoryManager();
    return _instance!;
  }

  /// This method is used to set the response of the api call
  /// in the memory, response is not overwritten if it already exists
  void setRequestResponse(
      String url, Map<String, dynamic>? queryParameters, Response value) {
    Request key = Request(url, queryParameters);
    if (_data[key] != null) return;
    if (_data.length > 20) clearOldestData();
    _data[key] = RequestResponse(value);
  }

  /// This method is used to get the response of the api call
  /// from the memory, returns null if the response does not exists
  /// or if the response is obsolete, see [_requestObsolecence]
  Response? getRequestResponse(
      String url, Map<String, dynamic>? queryParameters) {
    Request key = Request(url, queryParameters);
    if (_data[key] == null) {
      return null;
    }
    if (DateTime.now().difference(_data[key]!._date).inSeconds >
        _requestObsolecence) {
      _data.remove(key);
      return null;
    }
    return _data[key]?._data;
  }

  void clearData() {
    _data.clear();
  }

  void removeData(String key) {
    _data.remove(key);
  }

  void clearDataExcept(List<String> keys) {
    _data.removeWhere((key, value) => !keys.contains(key));
  }

  void clearDataExceptOne(String key) {
    _data.removeWhere((key, value) => key != key);
  }

  void clearOldestData() {
    _data.remove(_data.keys.first);
  }
}
