import 'package:flutter/material.dart';
import 'package:instagram/pages/feed_page.dart';
import 'package:instagram/pages/profile_page.dart';
import 'package:instagram/data/dummy_users.dart'; // currentUser

class InstagramMain extends StatefulWidget {
  const InstagramMain({super.key, required this.title});
  final String title;

  @override
  State<InstagramMain> createState() => _InstagramMainState();
}

class _InstagramMainState extends State<InstagramMain> {

  int _currentIndex = 0;

  Widget _buildBottomTab(int index, IconData icon) =>
      Expanded(
        child: InkWell(
          onTap: () {
            setState(() => _currentIndex = index);
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(
                icon,
                color: _currentIndex == index ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      );

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const FeedPage();
      case 4:
        return ProfilePage(user: currentUser);
      default:
        return const Center(child: Text('미완성'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () {},
        ),
        elevation: 1,
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),

      body: _buildBody(),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            _buildBottomTab(0, Icons.home),
            _buildBottomTab(1, Icons.search),
            _buildBottomTab(2, Icons.add_box_outlined),
            _buildBottomTab(3, Icons.smart_display_outlined),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() => _currentIndex = 4);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(currentUser.profileImagePath),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}