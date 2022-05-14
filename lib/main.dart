import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay_drink/app/application_initializer.dart';

void main() async {
  await BlocOverrides.runZoned(() async {
    await ApplicationInitializer().initAndRun();
  });
  // runApp(const MyApp());
}
