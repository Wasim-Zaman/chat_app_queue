import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/custom_text_form_field.dart';
import '../../constants.dart';
import '../../providers/friends/friends_provider.dart';

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
                _searchUsers(value);
              },
            ),
            const SizedBox(height: kDefaultPadding),
            // Show search results here
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final peopleState = ref.watch(peopleProvider);
                if (peopleState is PeopleLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _searchUsers(String username) {
    if (username.isNotEmpty) {
      ref.read(peopleProvider.notifier).searchUsers(username);
    }
  }
}
