import 'package:flutter/material.dart';
import 'package:instagram/pages/feed_page.dart';
import 'package:instagram/pages/profile_page.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/widgets/create_post/after_post_bottom_sheet.dart';
import 'package:instagram/app_flags.dart'; // ★ 전역 플래그

class InstagramMain extends StatefulWidget {
  final String title;
  final int initialIndex; // 0: 피드, 4: 프로필

  const InstagramMain({
    super.key,
    required this.title,
    this.initialIndex = 0,
  });

  @override
  State<InstagramMain> createState() => _InstagramMainState();
}

class _InstagramMainState extends State<InstagramMain> {
  late int _currentIndex;

  // 프로필 탭 전용 Navigator
  final GlobalKey<NavigatorState> _profileNavigatorKey =
  GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    // initialIndex == 4 이고, 아직 한 번도 안 띄웠을 때만 실행
    if (_currentIndex == 4 && !AppFlags.hasShownAfterPostSheet) {
      AppFlags.hasShownAfterPostSheet = true; // 다시는 안 뜨게
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAfterPostSheet();
      });
    }
  }

  void _showAfterPostSheet() {
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
        setState(() {
          _currentIndex = index;
        });
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

  // ░░ 탭별 화면 스위치 ░░
  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        const FeedPage(), // 0번 탭: 피드
        const Center(child: Text('Search')), // 1번 탭
        const Center(child: Text('Create')), // 2번 탭
        const Center(child: Text('Reels')), // 3번 탭

        // 4번 탭: 프로필 네비게이터
        Navigator(
          key: _profileNavigatorKey,
          onGenerateRoute: (settings) {
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => ProfilePage(user: currentUser),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if (_currentIndex == 4) {
                    // 이미 프로필 탭이면: nested navigator 스택을 루트까지 pop
                    _profileNavigatorKey.currentState
                        ?.popUntil((route) => route.isFirst);
                  } else {
                    // 다른 탭이면: 프로필 탭으로 전환
                    setState(() => _currentIndex = 4);
                  }
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