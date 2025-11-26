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

  // ░░ Bottom Tab 공통 위젯 ░░
  Widget _buildBottomTab(int index, IconData icon) => Expanded(
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

  // ░░ 바디 스위치 ░░
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

  // ░░ 탭별 AppBar 스위치 ░░
  PreferredSizeWidget _buildAppBar() {
    switch (_currentIndex) {
    // 피드 탭
      case 0:
        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.5,
          titleSpacing: 16,
          title: const Text(
            'Instagram',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              color: Colors.black,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        );

    // 프로필 탭
      case 4:
        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.5,
          titleSpacing: 16,
          title: Row(
            children: [
              Text(
                currentUser.userNickName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.black,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              color: Colors.black,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        );

    // 나머지 탭 (임시 공통 AppBar)
      default:
        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.5,
          titleSpacing: 16,
          title: const Text(
            'Instagram',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            _buildBottomTab(0, Icons.home),
            _buildBottomTab(1, Icons.search),
            _buildBottomTab(2, Icons.add_box_outlined),
            _buildBottomTab(3, Icons.smart_display_outlined),
            // 프로필 탭 (동그란 이미지)
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
                      backgroundImage:
                      AssetImage(currentUser.profileImagePath),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}