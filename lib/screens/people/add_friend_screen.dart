import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/custom_text_form_field.dart';
import '../../constants.dart';
import '../../providers/friends/friends_provider.dart';
import 'components/search_user_tile.dart';

class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Add Friend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _usernameController,
              hintText: "Enter username",
              prefixIcon: const Icon(Icons.person_search),
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                if (value.length >= 3) {
                  _searchUsers(value);
                }
              },
            ),
            const SizedBox(height: kDefaultPadding),
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final friendsState = ref.watch(friendsProvider);

                if (friendsState is FriendsSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (friendsState is FriendsSearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          friendsState.message,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (friendsState is FriendsSearchSuccess) {
                  final users = friendsState.users;
                  if (users.data?.isEmpty ?? true) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: Colors.grey,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No users found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: users.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final user = users.data![index];
                      return SearchUserTile(
                        user: user,
                        onSendRequest: () => _sendFriendRequest(user.id),
                        onCancelRequest: () => _cancelFriendRequest(user.id),
                        onAcceptRequest: () => _acceptFriendRequest(user.id),
                        onRejectRequest: () => _rejectFriendRequest(user.id),
                      );
                    },
                  );
                }

                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search,
                        color: Colors.grey,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Search for users to add as friends',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _searchUsers(String username) {
    if (username.isNotEmpty) {
      ref.read(friendsProvider.notifier).searchUsers(username);
    }
  }

  void _sendFriendRequest(String userId) {
    // TODO: Implement in friends provider
  }

  void _cancelFriendRequest(String userId) {
    // TODO: Implement in friends provider
  }

  void _acceptFriendRequest(String userId) {
    // TODO: Implement in friends provider
  }

  void _rejectFriendRequest(String userId) {
    // TODO: Implement in friends provider
  }
}
