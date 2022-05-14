import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/core/utils/log.dart';

abstract class Screen<BLOC extends Cubit> extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);
}

abstract class ScreenState<BLOC extends Cubit, STATE,
        SCREEN extends Screen<Cubit>> extends State<SCREEN>
    with RouteAware, WidgetsBindingObserver {
  late BLOC bloc;
  late StreamSubscription _blocSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _createBloc(context);
    onInitState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      onInactive();
    } else if (state == AppLifecycleState.paused) {
      onPause();
    } else if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onInitState() {}
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BLOC>.value(
      value: bloc,
      child: _buildView(context),
    );
  }

  @override
  void didPopNext() {
    onReturn();
  }

  void onReturn() {}
  void onPause() {}
  void onInactive() {}
  void onResume() {}
  BLOC _createBloc(BuildContext context) {
    logInfo('[$runtimeType]: createBloc()');
    bloc = createBloc(context);
    _blocSubscription = bloc.stream.listen(onBlocStateChange.call);
    return bloc;
  }

  BLOC createBloc(BuildContext context);
  void onBlocStateChange(dynamic state) {}
  Widget _buildView(BuildContext context) {
    logInfo('[$runtimeType]: _buildView()');
    return buildView(context);
  }

  Widget buildView(BuildContext context);
  @override
  void dispose() {
    logInfo('[$runtimeType]: dispose()');
    WidgetsBinding.instance!.removeObserver(this);
    bloc.close();
    _blocSubscription.cancel();

    onDispose();
    super.dispose();
  }

  void onDispose() {}
}
