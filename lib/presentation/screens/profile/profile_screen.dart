import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/domain/blocs/auth/auth_cubit.dart';
import 'package:pay_drink/domain/blocs/user/user_cubit.dart';
import 'package:pay_drink/domain/blocs/user/user_state.dart';
import 'package:pay_drink/presentation/components/widgets/card_widget.dart';
import 'package:pay_drink/presentation/components/widgets/loading_indicator.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserCubit bloc;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<UserCubit>(context);
    bloc.getUserModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<UserCubit, UserState>(
        bloc: bloc,
        builder: (BuildContext context, UserState state) {
          final userModel = state.userModel;
          final firstName = userModel?.firstName ?? '';
          final middleName = userModel?.middleName ?? '';
          final lastName = userModel?.lastName ?? '';

          final String userName = firstName +
              ' ' +
              middleName +
              (middleName.isNotEmpty ? ' ' : '') +
              lastName;
          return !state.isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: _signOutBtn(context)),
                      const SizedBox(
                        height: 50,
                      ),
                      CardWidget(
                        isLoading: state.isLoading,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FractionallySizedBox(
                                widthFactor: 0.8,
                                child: Text(
                                  userName,
                                  style: TextStyles.cardHeadingTextStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Birthdate: ' +
                                    (userModel?.birthdate.toString() ?? ''),
                                style: TextStyles.labelSmallRegularTextStyle
                                    .copyWith(
                                        fontSize: 14,
                                        color: AppColors.uiBlackColor,
                                        fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Email: ' + (userModel?.email ?? ''),
                                style: TextStyles.labelSmallRegularTextStyle
                                    .copyWith(fontSize: 14),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const CustomLoadingIndicator();
        },
      ),
    );
  }

  Widget _signOutBtn(BuildContext context) {
    return TextButton(
      onPressed: () => _onSignOutPressed(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Sign out',
        style: TextStyles.bodyTitleTextStyle.copyWith(
          color: AppColors.secondaryDarkRed,
        ),
      ),
    );
  }

  Future<void> _onSignOutPressed(BuildContext context) async {
    await BlocProvider.of<AuthCubit>(context).signOut();
    bloc.resetUserModel();
  }
}
