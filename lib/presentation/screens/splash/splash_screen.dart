import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/auth/auth_state.dart';
import 'package:pay_drink/presentation/screens/home/home_screen.dart';
import 'package:pay_drink/presentation/screens/login/login_screen.dart';
import 'package:pay_drink/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final AuthCubit bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<AuthCubit>(context);
    bloc.silentLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        bloc: bloc,
        listener: _checkAuth,
        builder: _buildBody,
      ),
    );
  }

  void _checkAuth(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      NavigationUtil.toScreenAndCleanBackstack(
        context: context,
        screen: const HomeScreen(),
      );
    }

    if (state is Unauthorized || state is AuthFailure) {
      NavigationUtil.toScreenReplacement(
        context: context,
        screen: const LoginScreen(),
      );
    }
  }

  Widget _buildBody(BuildContext context, AuthState state) {
    return const Center(
      child: Icon(
        Icons.local_drink_rounded,
        color: AppColors.facebookColor,
      ),
    );
  }
}
