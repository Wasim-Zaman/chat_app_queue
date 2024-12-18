import 'package:flutter/material.dart';

import '../../constants.dart';
import '../people/add_friend_screen.dart';
import '../people/friend_requests_screen.dart';
import '../people/people_screen.dart';
import 'components/body.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Body(), // Chats tab
    const PeopleScreen(), // People tab
    const Center(child: Text("Calls")), // Calls tab (placeholder)
    const Center(child: Text("Profile")), // Profile tab (placeholder)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        BottomNavigationBarItem(icon: Icon(Icons.call), label: "Calls"),
        BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 14,
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Text(_selectedIndex == 0 ? "Chats" : "People"),
      actions: [
        if (_selectedIndex == 1) ...[
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFriendScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Stack(
              children: [
                Icon(Icons.people_outline),
                Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      "2",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FriendRequestsScreen(),
              ),
            ),
          ),
        ],
        if (_selectedIndex == 0)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
      ],
    );
  }
}
