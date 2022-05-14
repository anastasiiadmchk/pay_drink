import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pay_drink/app/service_locator.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/models/user/user_model.dart';
import 'package:pay_drink/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final _firebaseAuth = locator<FirebaseAuth>();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<void> createFirestoreUser({required UserModel userModel}) async {
    try {
      final user = _firebaseAuth.currentUser;
      userModel = userModel.copyWith(
        email: user?.email,
        id: user?.uid,
      );
      await _usersCollection.doc(userModel.id).set(
        {
          'id': userModel.id,
          'birthdate': userModel.birthdate?.toUtc() ?? DateTime.now(),
          'createdAt': FieldValue.serverTimestamp(),
          'email': userModel.email,
          'firstName': userModel.firstName,
          'lastName': userModel.lastName,
          'middleName': userModel.middleName,
        },
      );
    } catch (e, s) {
      logError('AuthRepoImpl::createFirebaseUser:', error: e, stackTrace: s);
      return;
    }
  }

  @override
  Future<UserModel> getUserModel() async {
    try {
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId == null) {
        throw Exception('UserRepoImpl::getUserModel: userId = null');
      }
      final user = await _usersCollection.doc(userId).get();
      final UserModel userModel =
          UserModel.fromJson(user.data() as Map<String, dynamic>);
      return userModel;
    } catch (e, s) {
      logError('UserRepoImpl::getUserModel:', error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future<void> editUser({required UserModel userModel}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('UserRepoImpl::editUser: user = null');
      }
      await _usersCollection.doc(user.uid).update(
            ({
              'firstName': userModel.firstName,
              'lastName': userModel.lastName,
              'middleName': userModel.middleName,
              if (userModel.birthdate?.toUtc() != null)
                'birthdate': userModel.birthdate?.toUtc() ?? DateTime.now(),
            }),
          );
    } catch (e, s) {
      logError('UserRepoImpl::editUser:', error: e, stackTrace: s);
      return;
    }
  }
}
