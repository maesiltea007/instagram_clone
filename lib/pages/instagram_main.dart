import 'package:flutter/material.dart';
import 'package:instagram/pages/feed_page.dart';
import 'package:instagram/pages/profile_page.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/widgets/create_post/after_post_bottom_sheet.dart';
import 'package:instagram/pages/notifications_page.dart';

class InstagramMain extends StatefulWidget {
  final String title;
  final int initialIndex;   // ← 추가

  const InstagramMain({
    super.key,
    required this.title,
    this.initialIndex = 0,  // 기본은 피드
  });

  @override
  State<InstagramMain> createState() => _InstagramMainState();
}

class _InstagramMainState extends State<InstagramMain> {
  late int _currentIndex;
  bool _shouldShowAfterPostSheet = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // 프로필 탭으로 들어온 경우에만 after_post_bottom_sheet 자동 표시
    if (_currentIndex == 4) {
      _shouldShowAfterPostSheet = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAfterPostSheet();
      });
    }
  }

  void _showAfterPostSheet() {
    if (!_shouldShowAfterPostSheet) return;
    _shouldShowAfterPostSheet = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AfterPostBottomSheet(),
    );
  }

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
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const NotificationsPage(),
                    transitionDuration: Duration.zero,        // 들어갈 때 애니메이션 없음
                    reverseTransitionDuration: Duration.zero, // 뒤로 갈 때도 없음
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.send),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        );

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