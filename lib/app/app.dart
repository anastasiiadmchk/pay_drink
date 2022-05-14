import 'package:catcher/core/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/app/service_locator.dart';
import 'package:pay_drink/domain/blocs/product/product_cubit.dart';
import 'package:pay_drink/domain/blocs/vm/vm_cubit.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/qr/qr_cubit.dart';
import 'package:pay_drink/domain/blocs/user/user_cubit.dart';
import 'package:pay_drink/domain/blocs/products/products_cubit.dart';
import 'package:pay_drink/domain/repositories/auth_repo.dart';
import 'package:pay_drink/domain/repositories/real_db_repo.dart';
import 'package:pay_drink/domain/repositories/user_repo.dart';
import 'package:pay_drink/domain/repositories/vm_repo.dart';
import 'package:pay_drink/presentation/screens/splash/splash_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    _setPreferredOrientations();

    _setSystemUIOverlayStyle();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(
            userRepo: locator<UserRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            authRepo: locator<AuthRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProductsCubit(
            realDbRepo: locator<RealDbRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => ProductCubit(
              // productRepo: locator<VmStatisticRepo>(),
              ),
        ),
        BlocProvider(
          create: (context) => VmCubit(
            vmRepo: locator<VmRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => QrCubit(
            vmRepo: locator<VmRepo>(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: Catcher.navigatorKey,
        theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
        ),
        builder: (context, widget) {
          final scaleFactor =
              MediaQuery.of(context).copyWith(textScaleFactor: 1.0);

          return MediaQuery(
            data: scaleFactor,
            child: widget!,
          );
        },
        home: const SplashScreen(),
      ),
    );
  }

  void _setPreferredOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
