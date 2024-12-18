import 'package:chat/models/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user.dart';
import '../../services/http_service.dart';

part 'friends_state.dart';

// TODO: 1. State Notifier
// TODO: 2. State Notifier Provider

class PeopleNotifier extends StateNotifier<PeopleState> {
  PeopleNotifier() : super(PeopleInitial());

  final _httpService = HttpService();

  Future<void> searchUsers(String username) async {
    try {
      state = PeopleLoading();
      final response =
          await _httpService.request('/v1/user/search?query=$username');
      final apiResponse = ApiResponse<List<User>>.fromJson(
        response,
        (data) => List<User>.from(data.map((e) => User.fromJson(e))),
      );
      state = PeopleSuccess(apiResponse);
    } catch (e) {
      state = PeopleError(e.toString());
    }
  }
}

final peopleProvider =
    StateNotifierProvider<PeopleNotifier, PeopleState>((ref) {
  return PeopleNotifier();
});
