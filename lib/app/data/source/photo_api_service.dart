import 'dart:io';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'photo_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class PhotoApiService {
  factory PhotoApiService(Dio dio) {
    return _PhotoApiService(dio);
  }

  @GET('/api/get-photo')
  Future<HttpResponse<DataState>> get();

  @GET('{path}')
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> getBytes({@Path('path') required String path});

  @POST('/api/update-photo')
  @MultiPart()
  Future<HttpResponse<DataState>> updatePhoto({
    @Part(name: 'photo') required File photo,
  });
}
