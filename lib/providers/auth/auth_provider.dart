import 'package:chat/models/api_response.dart';
import 'package:chat/models/request/auth.dart';
import 'package:chat/services/http_service.dart';
import 'package:chat/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthInitial());

  final _httpService = HttpService();
  final _storageService = StorageService();

  Future<void> signUp(String username, String password) async {
    state = const AuthLoading();

    try {
      final response = await _httpService.request(
        '/v1/user/signup',
        method: HttpMethod.post,
        data: SignUpRequest(username: username, password: password).toJson(),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response,
        (data) => data,
      );

      state = AuthSuccess(apiResponse);
    } on HttpException catch (e) {
      state = AuthError(e.toString());
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> signIn(String username, String password) async {
    state = const AuthLoading();

    try {
      final response = await _httpService.request(
        '/v1/user/signin',
        method: HttpMethod.post,
        data: SignInRequest(username: username, password: password).toJson(),
      );

      final apiResponse = ApiResponse<dynamic>.fromJson(
        response,
        (data) => data,
      );

      // store token in shared preferences
      await _storageService.saveTokens(
        accessToken: apiResponse.data['tokens']['accessToken'],
        refreshToken: apiResponse.data['tokens']['refreshToken'],
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
