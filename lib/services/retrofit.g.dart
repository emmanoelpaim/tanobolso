// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://us-central1-celebra-6dd8b.cloudfunctions.net/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  postSendMail(json) async {
    ArgumentError.checkNotNull(json, 'json');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(json?.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('sendMailUser',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  postTokenizationCard(json) async {
    ArgumentError.checkNotNull(json, 'json');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(json?.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('tokenizationCard',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }

  @override
  postProcessPayment(json) async {
    ArgumentError.checkNotNull(json, 'json');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(json?.toJson() ?? <String, dynamic>{});
    final Response<String> _result = await _dio.request('processPayment',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = _result.data;
    return Future.value(value);
  }
}
