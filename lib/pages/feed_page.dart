import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_cards/post_card.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/pages/notifications_page.dart';
import 'package:instagram/pages/dm_list_page.dart';
import 'package:instagram/widgets/comment/comment_bottom_sheet.dart';

import '../data/dummy_users.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 피드에 보여줄 포스트만 필터링
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
            fontFamily: 'InstagramLogo', // 너 쓰는 폰트 있으면 유지 / 없으면 삭제
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
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
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

          // ---------------- Story Bar ------------------
          SizedBox(
            height: 102,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildStoryItem("Your story",
                    currentUser.profileImagePath, true),

                _buildStoryItem("imwinter",
                    "assets/images/profile_images/winter_profile.jpg", false),

                _buildStoryItem("katarinabluu",
                    "assets/images/profile_images/karina_profile.jpg", false),

                _buildStoryItem("aespa_official",
                    "assets/images/profile_images/aespa_logo.jpg", false),

                _buildStoryItem("sarang", "assets/images/profile_images/default_user_image.jpg", false),

                _buildStoryItem("joyuri", "assets/images/profile_images/default_user_image.jpg", false),
              ],
            ),
          ),

          const Divider(height: 1),

          // -------------- Posts ------------------
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

  // ---------------- Story Item Builder -----------------
  Widget _buildStoryItem(String label, String imgPath, bool isMine) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // 스토리 테두리 (남의 스토리일 때만 보라색 링)
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

              // 내 스토리는 테두리 없음
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
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