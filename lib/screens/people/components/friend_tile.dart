import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../models/user.dart';

class FriendTile extends StatelessWidget {
  final User user;
  final VoidCallback onRemove;

  const FriendTile({
    super.key,
    required this.user,
    required this.onRemove,
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
      trailing: IconButton(
        icon: const Icon(Icons.person_remove),
        onPressed: onRemove,
        color: Colors.red,
      ),
    );
  }
} 