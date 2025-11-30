import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/pages/profile_feed_page.dart';
import 'package:instagram/widgets/post_cards/post_pop_up.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/pages/following_page.dart';

class OthersProfilePage extends StatefulWidget {
  final User target; // 다른 사람 계정

  const OthersProfilePage({super.key, required this.target});

  @override
  State<OthersProfilePage> createState() => _OthersProfilePageState();
}

class _OthersProfilePageState extends State<OthersProfilePage> {
  OverlayEntry? _postOverlay;

  int _getPostCountFor(User user) {
    return dummyPosts.where((p) => p.authorid == user.id).length;
  }

  void _showPostPopup(BuildContext context, Post post) {
    _hidePostPopup();
    _postOverlay = OverlayEntry(
      builder: (_) => PostPopUp(post: post),
    );
    Overlay.of(context, rootOverlay: true).insert(_postOverlay!);
  }

  void _hidePostPopup() {
    _postOverlay?.remove();
    _postOverlay = null;
  }

  @override
  void dispose() {
    _hidePostPopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 항상 최신 dummy_users 기준으로 타깃 유저 가져오기
    final user = usersById[widget.target.id] ?? widget.target;
    final postCount = _getPostCountFor(user);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user, postCount),
            const SizedBox(height: 8),
            _buildUserInfo(user),
            const SizedBox(height: 12),
            _buildButtonsRow(user),
            const SizedBox(height: 16),
            _buildPostsSection(user),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ───────────────── APP BAR ─────────────────
  AppBar _buildAppBar(BuildContext context, User user) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Text(
            user.userNickName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.verified, color: Color(0xFF0095F6), size: 18),
        ],
      ),
      actions: const [
        Icon(Icons.notifications_none_outlined,
            color: Colors.black, size: 26),
        SizedBox(width: 16),
        Icon(Icons.more_vert, color: Colors.black, size: 26),
        SizedBox(width: 12),
      ],
    );
  }

  // ───────────────── HEADER (프로필 + 카운트) ─────────────────
  Widget _buildHeader(User user, int postCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundImage: AssetImage(user.profileImagePath),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _countBlock(postCount, "posts"),
                _countBlock(user.followerCount, "followers"),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            FollowingPage(owner: user),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: _countBlock(
                    user.followingCount,
                    "following",
                    showArrow: true,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _countBlock(int count, String label, {bool showArrow = false}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  // ───────────────── USER INFO (이름, bio, followed by) ─────────────────
  Widget _buildUserInfo(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 화면에 보이는 NAME (NINGNING)
          Text(
            user.userName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          // bio (있으면)
          if (user.bio.isNotEmpty) ...[
            Text(
              user.bio,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
          ],
          // 계정 설명 dummy: aespa
          const Text(
            'aespa',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          // Followed by ... dummy 영역
          Row(
            children: [
              const CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(
                  'assets/images/profile_images/winter_profile.jpg',
                ),
              ),
              const SizedBox(width: 4),
              const CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(
                  'assets/images/profile_images/karina_profile.jpg',
                ),
              ),
              const SizedBox(width: 4),
              const CircleAvatar(
                radius: 10,
                backgroundImage: AssetImage(
                  'assets/images/profile_images/aespa_logo.jpg',
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: 'Followed by '),
                      TextSpan(
                        text: 'imwinter',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ', '),
                      TextSpan(
                        text: 'katarinabluu',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'aespa_official',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────── FOLLOW / MESSAGE 버튼 ─────────────────
  Widget _buildButtonsRow(User user) {
    final bool amIFollowing = isFollowing(currentUser.id, user.id);

    const greyBg = Color(0xFFEFEFEF);
    const greyBorder = Color(0xFFDBDBDB);
    const followBlue = Color(0xFF0095F6);

    final Color followBg = amIFollowing ? greyBg : followBlue;
    final Color followTextColor =
    amIFollowing ? Colors.black : Colors.white;
    final Color followBorderColor =
    amIFollowing ? greyBorder : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // FOLLOW / FOLLOWING
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (amIFollowing) {
                    unfollowUser(currentUser.id, user.id);
                  } else {
                    followUser(currentUser.id, user.id);
                  }
                  // currentUser / target 유저 둘 다 dummy_users 안에서 이미 변경된다고 가정
                  // setState로 이 페이지는 즉시 리빌드
                });
              },
              child: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: followBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: followBorderColor),
                ),
                child: Center(
                  child: Text(
                    amIFollowing ? 'Following' : 'Follow',
                    style: TextStyle(
                      color: followTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // MESSAGE
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: greyBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: greyBorder),
              ),
              child: const Center(
                child: Text(
                  'Message',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 친구 추가 아이콘
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: greyBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: greyBorder),
            ),
            child: const Icon(Icons.person_add_outlined, size: 20),
          ),
        ],
      ),
    );
  }

  // ───────────────── POSTS GRID ─────────────────
  Widget _buildPostsSection(User user) {
    final posts = dummyPosts.where((p) => p.authorid == user.id).toList();

    return Column(
      children: [
        _buildTabs(),
        _buildGrid(user, posts),
      ],
    );
  }

  Widget _buildTabs() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.grid_on, size: 24),
                  const SizedBox(height: 6),
                  Container(height: 2, color: Colors.black),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Icon(
                    Icons.person_pin_outlined,
                    size: 24,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Container(height: 2, color: Colors.transparent),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildGrid(User user, List<Post> posts) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio: 1,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            // 프로필 피드로 이동, index 함께 전달
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProfileFeedPage(
                  targetUser: user,
                  initialIndex: index,
                ),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          onLongPressStart: (_) => _showPostPopup(context, post),
          onLongPressEnd: (_) => _hidePostPopup(),
          child: Image.asset(
            post.mediaPaths.first,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}