import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
import '../../services/storage_service.dart';

class UserProvider extends StateNotifier<User> {
  UserProvider() : super(User.empty());

  final _storageService = StorageService();

  Future<void> getUser() async {
    final user = await _storageService.getUser();
    state = user ?? User.empty();
  }
}

final userProvider = StateNotifierProvider<UserProvider, User>((ref) {
  return UserProvider();
});
