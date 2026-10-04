import 'package:absensi_2026/app/data/source/attendance_api_service.dart';
import 'package:absensi_2026/app/data/source/auth_api_service.dart';
import 'package:absensi_2026/app/data/source/leave_api_service.dart';
import 'package:absensi_2026/app/data/source/photo_api_service.dart';
import 'package:absensi_2026/app/data/source/schedule_api_service.dart';
import 'package:absensi_2026/app/module/repository/attendance_repository.dart';
import 'package:absensi_2026/app/module/repository/auth_repository.dart';
import 'package:absensi_2026/app/module/repository/leave_repository.dart';
import 'package:absensi_2026/app/module/repository/photo_repository.dart';
import 'package:absensi_2026/app/module/repository/schedule_repository.dart';
import 'package:absensi_2026/app/data/repository/attendance_repository.dart';
import 'package:absensi_2026/app/data/repository/auth_repository.dart';
import 'package:absensi_2026/app/data/repository/leave_repository.dart';
import 'package:absensi_2026/app/data/repository/photo_repository.dart';
import 'package:absensi_2026/app/data/repository/schedule_repository.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_by_month_year.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_this_month.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_today.dart';
import 'package:absensi_2026/app/module/use_case/attendance_send.dart';
import 'package:absensi_2026/app/module/use_case/auth_login.dart';
import 'package:absensi_2026/app/module/use_case/leave_send.dart';
import 'package:absensi_2026/app/module/use_case/leave_get.dart';
import 'package:absensi_2026/app/module/use_case/photo_get.dart';
import 'package:absensi_2026/app/module/use_case/photo_get_bytes.dart';
import 'package:absensi_2026/app/module/use_case/schedule_banned.dart';
import 'package:absensi_2026/app/module/use_case/holiday_get.dart';
import 'package:absensi_2026/app/module/use_case/schedule_get.dart';
import 'package:absensi_2026/app/presentation/calendar/calendar_notifier.dart';
import 'package:absensi_2026/app/presentation/detail_attendance/detail_attendance_notifier.dart';
import 'package:absensi_2026/app/presentation/face_recognition/face_recognition_notifier.dart';
import 'package:absensi_2026/app/presentation/home/home_notifier.dart';
import 'package:absensi_2026/app/presentation/leave/leave_notifier.dart';
import 'package:absensi_2026/app/presentation/login/login_notifier.dart';
import 'package:absensi_2026/app/presentation/main/main_notifier.dart';
import 'package:absensi_2026/app/presentation/profile/profile_notifier.dart';
import 'package:absensi_2026/app/presentation/map/map_notifier.dart';
import 'package:absensi_2026/app/presentation/upload_photo/upload_photo_notifier.dart';
import 'package:absensi_2026/app/presentation/security/security_attendance_notifier.dart';
import 'package:absensi_2026/app/module/use_case/auth_logout.dart';
import 'package:absensi_2026/app/module/use_case/photo_update.dart';
import 'package:absensi_2026/core/network/app_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:absensi_2026/core/service/biometric_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final sl = GetIt.instance;

Future<void> initDependency() async {
  //dio
  Dio dio = Dio();
  dio.interceptors.add(AppInterceptor());
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      compact: true,
    ),
  );
  sl.registerSingleton<Dio>(dio);
  sl.registerSingleton<BiometricService>(BiometricService());

  //apiservice
  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<AttendanceApiService>(AttendanceApiService(sl()));
  sl.registerSingleton<LeaveApiService>(LeaveApiService(sl()));
  sl.registerSingleton<PhotoApiService>(PhotoApiService(sl()));
  sl.registerSingleton<ScheduleApiService>(ScheduleApiService(sl()));

  //repository
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<AttendanceRepository>(AttendanceRepositoryImpl(sl()));
  sl.registerSingleton<LeaveRepository>(LeaveRepositoryImpl(sl()));
  sl.registerSingleton<PhotoRepository>(PhotoRepositoryImpl(sl()));
  sl.registerSingleton<ScheduleRepository>(ScheduleRepositoryImpl(sl()));

  //usecase
  sl.registerSingleton<AuthLoginUseCase>(AuthLoginUseCase(sl()));
  sl.registerSingleton<AuthLogoutUseCase>(AuthLogoutUseCase(sl()));
  sl.registerSingleton<AttendanceGetTodayUseCase>(
    AttendanceGetTodayUseCase(sl()),
  );
  sl.registerSingleton<AttendanceGetMonthUseCase>(
    AttendanceGetMonthUseCase(sl()),
  );
  sl.registerSingleton<AttendanceGetByMonthYearUseCase>(
    AttendanceGetByMonthYearUseCase(sl()),
  );
  sl.registerSingleton<HolidayGetUseCase>(HolidayGetUseCase(sl()));
  sl.registerSingleton<AttendanceSendUseCase>(AttendanceSendUseCase(sl()));
  sl.registerSingleton<LeaveSendUseCase>(LeaveSendUseCase(sl()));
  sl.registerSingleton<LeaveGetUseCase>(LeaveGetUseCase(sl()));
  sl.registerSingleton<PhotoGetUseCase>(PhotoGetUseCase(sl()));
  sl.registerSingleton<PhotoGetBytesUseCase>(PhotoGetBytesUseCase(sl()));
  sl.registerSingleton<PhotoUpdateUseCase>(PhotoUpdateUseCase(sl()));
  sl.registerSingleton<ScheduleGetUseCase>(ScheduleGetUseCase(sl()));
  sl.registerSingleton<ScheduleBannedUseCase>(ScheduleBannedUseCase(sl()));

  //provider
  sl.registerFactoryParam<LoginNotifier, void, void>(
    (param1, param2) => LoginNotifier(sl(), sl()),
  );
  sl.registerFactoryParam<HomeNotifier, void, void>(
    (param1, param2) => HomeNotifier(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactoryParam<FaceRecognitionNotifier, void, void>(
    (param1, param2) => FaceRecognitionNotifier(sl(), sl(), sl(), sl()),
  );
  sl.registerFactoryParam<LeaveNotifier, void, void>(
    (param1, param2) => LeaveNotifier(sl(), sl()),
  );
  sl.registerFactoryParam<CalendarNotifier, void, void>(
    (param1, param2) => CalendarNotifier(sl(), sl()),
  );
  sl.registerFactoryParam<DetailAttendanceNotifier, void, void>(
    (param1, param2) => DetailAttendanceNotifier(sl()),
  );
  sl.registerFactoryParam<MainNotifier, void, void>(
    (param1, param2) => MainNotifier(),
  );
  sl.registerFactoryParam<UploadPhotoNotifier, void, void>(
    (param1, param2) => UploadPhotoNotifier(sl()),
  );
  sl.registerFactoryParam<ProfileNotifier, void, void>(
    (param1, param2) => ProfileNotifier(sl(), sl(), sl()),
  );
  sl.registerFactoryParam<MapNotifier, void, void>(
    (param1, param2) => MapNotifier(sl(), sl(), sl()),
  );
  sl.registerFactoryParam<SecurityAttendanceNotifier, void, void>(
    (param1, param2) => SecurityAttendanceNotifier(sl()),
  );
}
