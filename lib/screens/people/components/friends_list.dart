import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsList extends ConsumerWidget {
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
    // final state = ref.watch(friendsProvider);

    // return state.when(
    //   initial: () => const Center(child: Text('No friends yet')),
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error: (message) => Center(child: Text(message)),
    //   success: (friends) => friends.isEmpty
    //       ? const Center(child: Text('No friends yet'))
    //       : ListView.builder(
    //           padding: const EdgeInsets.all(kDefaultPadding),
    //           itemCount: friends.length,
    //           itemBuilder: (context, index) => FriendTile(
    //             user: friends[index],
    //             onRemove: () => ref
    //                 .read(friendsProvider.notifier)
    //                 .removeFriend(friends[index].id),
    //           ),
    //         ),
    //   friendRequestsSuccess: (_) =>
    //       const Center(child: Text('Something went wrong')),
    // );
  }
}
