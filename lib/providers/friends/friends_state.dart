part of 'friends_provider.dart';

// People

sealed class FriendsState {}

class FriendsInitial extends FriendsState {}

class FriendsSearchLoading extends FriendsState {}

class FriendsSearchSuccess extends FriendsState {
  final ApiResponse<List<User>> users;
  FriendsSearchSuccess(this.users);
}

class FriendsSearchError extends FriendsState {
  final String message;
  FriendsSearchError(this.message);
}

// Friends
