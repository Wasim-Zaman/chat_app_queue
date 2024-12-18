import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  @override
  void initState() {
    super.initState();
    // ref.read(friendsProvider.notifier).getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // final state = ref.watch(searchUsersProvider);

    // return state.when(
    //   initial: () => const Center(child: Text('No friends yet')),
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error: (message) => Center(child: Text(message)),
    //   success: (friends) => friends.isEmpty
    //       ? const Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Icon(Icons.people_outline, size: 64, color: Colors.grey),
    //               SizedBox(height: 16),
    //               Text(
    //                 'No friends yet',
    //                 style: TextStyle(fontSize: 16, color: Colors.grey),
    //               ),
    //               Text(
    //                 'Add friends to start chatting',
    //                 style: TextStyle(color: Colors.grey),
    //               ),
    //             ],
    //           ),
    //         )
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
