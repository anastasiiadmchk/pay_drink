import 'package:pay_drink/domain/models/user/user_model.dart';

abstract class UserRepo {
  Future<UserModel> getUserModel();
  Future<void> createFirestoreUser({required UserModel userModel});
  Future<void> editUser({required UserModel userModel});
}
