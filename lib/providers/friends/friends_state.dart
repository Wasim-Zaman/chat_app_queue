part of 'friends_provider.dart';

// People

sealed class PeopleState {}

class PeopleInitial extends PeopleState {}

class PeopleLoading extends PeopleState {}

class PeopleSuccess extends PeopleState {
  final ApiResponse<List<User>> users;
  PeopleSuccess(this.users);
}

class PeopleError extends PeopleState {
  final String message;
  PeopleError(this.message);
}

// Friends

sealed class FriendsState {
  const FriendsState();

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<User> friends) success,
    required T Function(List<User> requests) friendRequestsSuccess,
  });
}

class FriendsInitial extends FriendsState {
  const FriendsInitial();

  @override
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<User> friends) success,
    required T Function(List<User> requests) friendRequestsSuccess,
  }) =>
      initial();
}

class FriendsLoading extends FriendsState {
  const FriendsLoading();

  @override
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<User> friends) success,
    required T Function(List<User> requests) friendRequestsSuccess,
  }) =>
      loading();
}

class FriendsSuccess extends FriendsState {
  final List<User> friends;
  const FriendsSuccess(this.friends);

  @override
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<User> friends) success,
    required T Function(List<User> requests) friendRequestsSuccess,
  }) =>
      success(friends);
}

class FriendRequestsSuccess extends FriendsState {
  final List<User> requests;
  const FriendRequestsSuccess(this.requests);

  @override
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<User> friends) success,
    required T Function(List<User> requests) friendRequestsSuccess,
  }) =>
      friendRequestsSuccess(requests);
}

class FriendsError extends FriendsState {
  final String message;
  const FriendsError(this.message);

  @override
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String message) error,
    required T Function(List<User> friends) success,
    required T Function(List<User> requests) friendRequestsSuccess,
  }) =>
      error(message);
}
