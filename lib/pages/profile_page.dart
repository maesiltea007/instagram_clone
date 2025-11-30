import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/widgets/create_post/create_bottom_sheet.dart';
import 'package:instagram/pages/edit_profile_page.dart';

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
          _buildButtonsRow(context, user),      // ← user 넘김
          const SizedBox(height: 16),
          _buildPostsSection(user, context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ───────────────── 헤더 ─────────────────
  Widget _buildHeader(User user, int postCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(user.profileImagePath),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _StatItem(label: 'posts', count: postCount),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'followers',
                        count: user.followerCount,
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        label: 'following',
                        count: user.followingCount,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── bio ─────────────────
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

  // ───────────────── 버튼 줄 ─────────────────
  Widget _buildButtonsRow(BuildContext context, User user) {
    final Color bg = const Color(0xFFEFEFEF);
    final Color border = const Color(0xFFDBDBDB);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: border),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => EditProfilePage(user: user),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: const Text(
                  'Edit profile',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 32,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: border),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Share profile',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: border),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.person_add_outlined,
                size: 18,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  // ───────── 상단 탭 + 그리드 전체 섹션 ─────────
  Widget _buildPostsSection(User user, BuildContext context) {
    final List<Post> userPosts =
    dummyPosts.where((p) => p.authorid == user.id).toList();

    return Column(
      children: [
        _buildPostTabs(),
        _buildPostGrid(userPosts, context),
      ],
    );
  }

  Widget _buildPostTabs() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.grid_on, size: 24),
                  const SizedBox(height: 6),
                  Container(
                    height: 1.5,
                    color: Colors.black,
                  ),
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
                  Container(
                    height: 1.5,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildPostGrid(List<Post> userPosts, BuildContext context) {
    final itemCount = userPosts.isEmpty ? 1 : userPosts.length + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 1),
      itemCount: itemCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        if (index == userPosts.length) {
          return _buildAddPostTile(context);
        }

        if (userPosts.isEmpty) {
          return _buildAddPostTile(context);
        }

        final post = userPosts[index];

        if (!post.isVideo) {
          return Image.asset(
            post.mediaPaths.first,
            fit: BoxFit.cover,
          );
        }

        return Container(
          color: Colors.black12,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 32,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddPostTile(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => const CreateBottomSheet(),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: 32,
            color: Colors.grey.shade700,
          ),
        ),
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