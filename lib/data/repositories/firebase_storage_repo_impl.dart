import 'dart:collection';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:pay_drink/core/utils/log.dart';
import 'package:pay_drink/domain/repositories/firebase_storage_repo.dart';

class FirebaseStorageRepoImpl implements FirebaseStorageRepo {
  final _cacheUrls = HashMap<String, String>();
  @override
  Future<String> getDownloadFileLink({required String fileReference}) async {
    try {
      if (_cacheUrls.containsKey(fileReference)) {
        return _cacheUrls[fileReference]!;
      }

      final reference = fileReference.contains('gs://')
          ? FirebaseStorage.instance.refFromURL(fileReference)
          : FirebaseStorage.instance.ref(fileReference);

      final imageUrl = await reference.getDownloadURL();
      _cacheUrls[fileReference] = imageUrl;
      return imageUrl;
    } catch (e, s) {
      logError('RepoImpl::getImageLink:', error: e, stackTrace: s);
      return '';
    }
  }
}
