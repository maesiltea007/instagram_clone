// lib/pages/feed_page.dart
import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_cards/post_card.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/pages/notifications_page.dart';
import 'package:instagram/pages/dm_list_page.dart';
import 'package:instagram/widgets/comment/comment_bottom_sheet.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_notifications.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final feedPosts = dummyPosts.where((post) => post.showFeed).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: const Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontSize: 26,
            fontFamily: 'InstagramLogo',
          ),
        ),
        actions: [
          // ★ 알림 아이콘 + 뱃지
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.favorite_border),
                if (unreadNotificationCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        unreadNotificationCount.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context)
                  .push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const NotificationsPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              )
                  .then((_) {
                // 알림 페이지에서 읽음 처리 후 돌아오면 배지 상태 갱신
                setState(() {});
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const DmListPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),

      // -------- BODY --------
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // 스토리 바
          SizedBox(
            height: 102,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildStoryItem(
                    "Your story", currentUser.profileImagePath, true),
                _buildStoryItem("imwinter",
                    "assets/images/profile_images/winter_profile.jpg", false),
                _buildStoryItem("katarinabluu",
                    "assets/images/profile_images/karina_profile.jpg", false),
                _buildStoryItem("aespa_official",
                    "assets/images/profile_images/aespa_logo.jpg", false),
                _buildStoryItem("sarang",
                    "assets/images/profile_images/default_user_image.jpg",
                    false),
                _buildStoryItem("joyuri",
                    "assets/images/profile_images/default_user_image.jpg",
                    false),
              ],
            ),
          ),
          const Divider(height: 1),
          // 포스트들
          for (final post in feedPosts)
            PostCard(
              post: post,
              onCommentTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => CommentsBottomSheet(post: post),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(String label, String imgPath, bool isMine) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (!isMine)
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFDE0046),
                        Color(0xFFF7A34B),
                      ],
                    ),
                  ),
                ),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(isMine ? 2 : 3),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(imgPath),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 70,
            child: Text(
              label,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}