part of 'friends_provider.dart';

// People

sealed class FriendsState {}

class FriendsInitial extends FriendsState {
  final ApiResponse<List<User>>? apiResponse;
  FriendsInitial({this.apiResponse});
}

class FriendsSearchLoading extends FriendsState {
  final ApiResponse<List<User>>? apiResponse;
  FriendsSearchLoading({this.apiResponse});
}

class FriendsSearchSuccess extends FriendsState {
  final ApiResponse<List<User>>? apiResponse;
  FriendsSearchSuccess({this.apiResponse});
}

class FriendsSearchError extends FriendsState {
  final ApiResponse<List<User>>? apiResponse;
  FriendsSearchError({this.apiResponse});
}

// * Request

class RequestInitial extends FriendsState {}

class RequestLoading extends FriendsState {}

class RequestSuccess extends FriendsState {}

class RequestError extends FriendsState {}
