import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/models/post.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  int _getPostCountForUser(User user) {
    return dummyPosts.where((Post post) => post.authorid == user.id).length;
  }

  @override
  Widget build(BuildContext context) {
    final postCount = _getPostCountForUser(user);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(user, postCount),
          const SizedBox(height: 8),
          _buildUserInfo(user),
          const SizedBox(height: 12),
          _buildButtonsRow(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(User user, int postCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(user.profileImagePath),
          ),
          const SizedBox(width: 20),

          // 통계 영역
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _StatItem(label: 'posts', count: postCount),
                ),
                Expanded(
                  child: _StatItem(label: 'followers', count: user.followerCount),
                ),
                Expanded(
                  child: _StatItem(label: 'following', count: user.followingCount),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// bio 줄
  Widget _buildUserInfo(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.bio.isNotEmpty)
            Text(
              user.bio,
              style: const TextStyle(fontSize: 14),
            ),
        ],
      ),
    );
  }

  /// Edit profile / Share profile / 사람 아이콘 버튼
  Widget _buildButtonsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Edit profile
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 너무 동글지 않게
                ),
              ),
              child: const Text(
                'Edit profile',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Share profile
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Share profile',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // 사람 아이콘 버튼
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.white,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.person_add_outlined,
                size: 18,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int count;

  const _StatItem({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}