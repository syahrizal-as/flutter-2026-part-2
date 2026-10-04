import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'leave_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class LeaveApiService {
  factory LeaveApiService(Dio dio) {
    return _LeaveApiService(dio);
  }

  @POST('/api/send-leave')
  Future<HttpResponse<DataState>> send({
    @Body() required Map<String, dynamic> body,
  });

  @GET('/api/leaves')
  Future<HttpResponse<DataState>> getLeaves();
}
