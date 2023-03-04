import 'package:flutter/material.dart';

//p
import '../pages/chats_page.dart';
import '../pages/users_page.dart';
import 'bubbles_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 1;
  final List<Widget> _pages = [
    const ChatsPage(),
    const BubblesPage(),
    const UsersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: "Chats", icon: Icon(Icons.chat)),
          BottomNavigationBarItem(label: "Bubbles", icon: Icon(Icons.circle)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
