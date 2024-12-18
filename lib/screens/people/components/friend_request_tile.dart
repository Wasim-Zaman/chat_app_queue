import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/user.dart';

class FriendRequestTile extends StatelessWidget {
  final User user;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestTile({
    super.key,
    required this.user,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: kPrimaryColor,
        backgroundImage: user.avatar != null ? NetworkImage(user.avatar!) : null,
        child: user.avatar == null
            ? Text(user.username[0].toUpperCase(),
                style: const TextStyle(color: Colors.white))
            : null,
      ),
      title: Text(user.username),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: onAccept,
            color: Colors.green,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onReject,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
} 