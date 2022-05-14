import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/navigation.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/auth/auth_state.dart';
import 'package:pay_drink/presentation/screens/login/login_screen.dart';
import 'package:pay_drink/presentation/screens/profile/profile_screen.dart';
import 'package:pay_drink/presentation/screens/qr/scanner_page.dart';
import 'package:pay_drink/presentation/screens/vm/vm_screen.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const EdgeInsets _iconPadding = EdgeInsets.only(bottom: 4.0);
  late final AuthCubit authCubit;
  late ValueNotifier<int> _selectedTabIndex;

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = ValueNotifier<int>(0);
    authCubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedTabIndex,
      builder: (BuildContext context, int value, Widget? child) => Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,
          listener: _listener,
          builder: (context, state) => _buildBody(value),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AuthState state) {
    if (state is Unauthorized) {
      NavigationUtil.toScreenAndCleanBackstack(
        context: context,
        screen: const LoginScreen(),
      );
    }
  }

  Color _iconColor(bool selected) =>
      selected ? AppColors.uiDarkGrey : AppColors.uiLightGrey;

  Widget _buildBody(int index) {
    return ScannerPage();
    // VMScreen();
    // ProfileScreen(),
    // ],
    // );
  }

  void _onBarIconTapped(index) {
    _selectedTabIndex.value = index;
  }
}
