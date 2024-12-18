import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendRequestsScreen extends ConsumerStatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  ConsumerState<FriendRequestsScreen> createState() =>
      _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends ConsumerState<FriendRequestsScreen> {
  @override
  void initState() {
    super.initState();
    // ref.read(friendsProvider.notifier).getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // final state = ref.watch(friendsProvider);

    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: kPrimaryColor,
    //     title: const Text('Friend Requests'),
    //   ),
    //   body: state.when(
    //     initial: () => const Center(child: Text('No friend requests')),
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //     error: (message) => Center(child: Text(message)),
    //     success: (_) => const Center(child: Text('Something went wrong')),
    //     friendRequestsSuccess: (requests) => requests.isEmpty
    //         ? const Center(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Icon(Icons.people_outline, size: 64, color: Colors.grey),
    //                 SizedBox(height: 16),
    //                 Text(
    //                   'No friend requests',
    //                   style: TextStyle(fontSize: 16, color: Colors.grey),
    //                 ),
    //               ],
    //             ),
    //           )
    //         : ListView.builder(
    //             padding: const EdgeInsets.all(kDefaultPadding),
    //             itemCount: requests.length,
    //             itemBuilder: (context, index) => FriendRequestTile(
    //               user: requests[index],
    //               onAccept: () {
    //                 ref
    //                     .read(friendsProvider.notifier)
    //                     .acceptFriendRequest(requests[index].id);
    //                 if (requests.length == 1) {
    //                   Navigator.pop(context);
    //                 }
    //               },
    //               onReject: () {
    //                 ref
    //                     .read(friendsProvider.notifier)
    //                     .rejectFriendRequest(requests[index].id);
    //                 if (requests.length == 1) {
    //                   Navigator.pop(context);
    //                 }
    //               },
    //             ),
    //           ),
    //   ),
    // );
  }
}
