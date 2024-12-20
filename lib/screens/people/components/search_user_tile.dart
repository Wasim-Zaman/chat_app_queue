import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/user.dart';

class SearchUserTile extends StatelessWidget {
  final User user;
  final VoidCallback? onSendRequest;
  final VoidCallback? onCancelRequest;
  final VoidCallback? onAcceptRequest;
  final VoidCallback? onRejectRequest;

  const SearchUserTile({
    super.key,
    required this.user,
    this.onSendRequest,
    this.onCancelRequest,
    this.onAcceptRequest,
    this.onRejectRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: kPrimaryColor,
          backgroundImage:
              user.avatar != null ? NetworkImage(user.avatar!) : null,
          child: user.avatar == null
              ? Text(
                  "${user.username[0].toUpperCase()}${user.username[user.username.length - 1].toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        title: Text(
          user.username,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        trailing: _buildActionButton(),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (user.friendshipStatus) {
      case FriendshipStatus.none:
        return ElevatedButton.icon(
          onPressed: onSendRequest,
          icon: const Icon(Icons.person_add_outlined, size: 20),
          label: const Text('Add Friend'),
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

      case FriendshipStatus.pending:
        return OutlinedButton.icon(
          onPressed: onCancelRequest,
          icon: const Icon(Icons.pending_outlined, size: 20),
          label: const Text('Cancel Request'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey,
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

      case FriendshipStatus.requested:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: onAcceptRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Accept'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onRejectRequest,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reject'),
            ),
          ],
        );

      case FriendshipStatus.friends:
        return TextButton.icon(
          onPressed: null,
          icon: const Icon(Icons.people, size: 20),
          label: const Text('Friends'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
    }
  }
}
