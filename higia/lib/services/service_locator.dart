import 'package:get_it/get_it.dart';
import 'package:higia/services/auth_service.dart';
import 'package:higia/services/user_service.dart';
import 'package:higia/services/step_counter_service.dart';
import 'package:higia/services/lookup_service.dart';
import 'package:higia/services/steps_repository.dart';

final GetIt locator = GetIt.instance;

Future<void> initServiceLocator() async {
  // Register singletons
  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
  locator.registerLazySingleton<StepCounterService>(() => StepCounterService());
  locator.registerLazySingleton<LookupService>(() => LookupService());
  locator.registerLazySingleton<StepsRepository>(() => StepsRepository());
}

T getIt<T extends Object>() => locator<T>();
