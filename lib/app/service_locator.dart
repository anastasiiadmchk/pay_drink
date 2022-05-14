import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:pay_drink/data/repositories/analytics_repo_impl.dart';
import 'package:pay_drink/data/repositories/auth_repo_impl.dart';
import 'package:pay_drink/data/repositories/firebase_storage_repo_impl.dart';
import 'package:pay_drink/data/repositories/real_db_repo_impl.dart';
import 'package:pay_drink/data/repositories/user_repo_impl.dart';
import 'package:pay_drink/data/repositories/vm_repo_impl.dart';
import 'package:pay_drink/domain/repositories/analytics_repo.dart';
import 'package:pay_drink/domain/repositories/auth_repo.dart';
import 'package:pay_drink/domain/repositories/firebase_storage_repo.dart';
import 'package:pay_drink/domain/repositories/real_db_repo.dart';
import 'package:pay_drink/domain/repositories/user_repo.dart';
import 'package:pay_drink/domain/repositories/vm_repo.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  await locator.reset();

  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // setup repos
  locator.registerLazySingleton<AnalyticsRepo>(() => AnalyticsRepoImpl());
  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  locator.registerLazySingleton<UserRepo>(() => UserRepoImpl());
  locator.registerLazySingleton<VmRepo>(() => VmRepoImpl());
  locator.registerLazySingleton<RealDbRepo>(() => RealDbRepoImpl());
  // locator.registerLazySingleton<VmStatisticRepo>(() => VmStatisticRepoImpl());
  locator.registerLazySingleton<FirebaseStorageRepo>(
    () => FirebaseStorageRepoImpl(),
  );
}
