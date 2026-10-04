import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/constant/constant.dart';

part 'attendance_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class AttendanceApiService {
  factory AttendanceApiService(Dio dio) {
    return _AttendanceApiService(dio);
  }

  @GET('/api/get-attendance-today')
  Future<HttpResponse<DataState>> getAttendanceToday();

  @POST('/api/send-attendance')
  Future<HttpResponse<DataState>> sendAttendance(
    @Body() Map<String, dynamic> body,
  );

  @GET('/api/get-attendance-by-month-year')
  Future<HttpResponse<DataState>> getAttendanceByMonthYear(
    @Query('month') int month,
    @Query('year') int year,
  );

  @GET('/api/get-holidays')
  Future<HttpResponse<DataState>> getHolidays(
    @Query('month') int month,
    @Query('year') int year,
  );

  @GET('/api/get-offices')
  Future<HttpResponse<DataState>> getOffices();

  @GET('/api/get-employees-by-office/{officeId}')
  Future<HttpResponse<DataState>> getEmployeesByOffice(@Path('officeId') int officeId);

  @POST('/api/send-attendance-security')
  Future<HttpResponse<DataState>> sendAttendanceSecurity(@Body() Map<String, dynamic> body);

  @POST('/api/update-employee-photo')
  Future<HttpResponse<DataState>> updateEmployeePhoto(@Body() Map<String, dynamic> body);
}