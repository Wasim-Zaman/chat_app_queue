import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendRequestsList extends ConsumerWidget {
  const FriendRequestsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
    // final state = ref.watch(friendsProvider);

    // return state.when(
    //   initial: () => const Center(child: Text('No friend requests')),
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error: (message) => Center(child: Text(message)),
    //   success: (_) => const Center(child: Text('Something went wrong')),
    //   friendRequestsSuccess: (requests) => requests.isEmpty
    //       ? const Center(child: Text('No friend requests'))
    //       : ListView.builder(
    //           padding: const EdgeInsets.all(kDefaultPadding),
    //           itemCount: requests.length,
    //           itemBuilder: (context, index) => FriendRequestTile(
    //             user: requests[index],
    //             onAccept: () => ref
    //                 .read(friendsProvider.notifier)
    //                 .acceptFriendRequest(requests[index].id),
    //             onReject: () => ref
    //                 .read(friendsProvider.notifier)
    //                 .rejectFriendRequest(requests[index].id),
    //           ),
    //         ),
    // );
  }
}
