import 'package:chat/models/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
import '../../services/http_service.dart';

part 'friends_state.dart';

// TODO: 1. State Notifier
// TODO: 2. State Notifier Provider

class FriendsNotifier extends StateNotifier<FriendsState> {
  FriendsNotifier() : super(FriendsInitial());

  final _httpService = HttpService();

  Future<void> searchUsers(String username) async {
    try {
      state = FriendsSearchLoading();
      final response =
          await _httpService.request('/v1/user/search?query=$username');
      final apiResponse = ApiResponse<List<User>>.fromJson(
        response,
        (data) => List<User>.from(data['users'].map((e) => User.fromJson(e))),
      );
      state = FriendsSearchSuccess(apiResponse);
    } catch (e) {
      state = FriendsSearchError(e.toString());
    }
  }
}

final friendsProvider =
    StateNotifierProvider<FriendsNotifier, FriendsState>((ref) {
  return FriendsNotifier();
});
