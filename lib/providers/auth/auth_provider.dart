import 'package:chat/models/api_response.dart';
import 'package:chat/services/http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthInitial());

  final _httpService = HttpService();

  Future<void> signUp(String username, String password) async {
    state = const AuthLoading();

    try {
      final response = await _httpService.request(
        '/v1/user/signup',
        method: HttpMethod.post,
        data: {
          'username': username,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response,
        (data) => data,
      );

      state = AuthSuccess(apiResponse);
    } on HttpException catch (e) {
      state = AuthError(e.message);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
