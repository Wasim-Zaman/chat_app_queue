class User {
  final String id;
  final String username;
  final String? avatar;
  final bool isOnline;
  final FriendshipStatus friendshipStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    this.avatar,
    this.isOnline = false,
    this.friendshipStatus = FriendshipStatus.none,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      username: json['username'],
      avatar: json['avatar'],
      isOnline: json['is_online'] ?? false,
      friendshipStatus: _getFriendshipStatus(json['friendship_status']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (avatar != null) 'avatar': avatar,
      'is_online': isOnline,
      'friendship_status': friendshipStatus.name,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  static FriendshipStatus _getFriendshipStatus(String? status) {
    if (status == null) return FriendshipStatus.none;

    return FriendshipStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == status.toLowerCase(),
      orElse: () => FriendshipStatus.none,
    );
  }

  User copyWith({
    String? id,
    String? username,
    String? avatar,
    bool? isOnline,
    FriendshipStatus? friendshipStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      friendshipStatus: friendshipStatus ?? this.friendshipStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.username == username &&
        other.avatar == avatar &&
        other.isOnline == isOnline &&
        other.friendshipStatus == friendshipStatus &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        avatar.hashCode ^
        isOnline.hashCode ^
        friendshipStatus.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

enum FriendshipStatus {
  none,
  pending, // We sent a friend request
  requested, // We received a friend request
  friends, // We are friends
}

extension FriendshipStatusExtension on FriendshipStatus {
  bool get isFriend => this == FriendshipStatus.friends;
  bool get isPending => this == FriendshipStatus.pending;
  bool get isRequested => this == FriendshipStatus.requested;
  bool get isNone => this == FriendshipStatus.none;
}
