import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/pages/others_profile_page.dart';

class FollowingPage extends StatelessWidget {
  final User owner;

  const FollowingPage({
    super.key,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    final List<User> following = getFollowingUsers(owner.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========= 상단 헤더 =========
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Center(
                  child: Text(
                    owner.userNickName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        // ========= Top Tabs =========
        _buildTopTabs(owner),

        // ========= 검색창 =========
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ========= Sync contacts 영역 =========
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.contacts_outlined,
                  color: Colors.black,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync contacts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Find people you know',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3897F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Sync',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.close, size: 18, color: Colors.grey),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ========= Sorted by Default =========
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Text(
                'Sorted by Default',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Icon(
                Icons.swap_vert,
                size: 20,
                color: Colors.black,
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
        const Divider(height: 1),

        // ========= 팔로잉 리스트 =========
        Expanded(
          child: ListView.builder(
            itemCount: following.length,
            itemBuilder: (context, index) {
              final u = following[index];

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          OthersProfilePage(target: u),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: _FollowingListItem(user: u),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopTabs(User owner) {
    final followersCount = owner.followerCount;
    final followingCount = owner.followingCount;

    Widget buildTab(String label, String count, bool isSelected) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Text(
              '$count $label',
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 1.5,
              color: isSelected ? Colors.black : Colors.transparent,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            buildTab('followers', followersCount.toString(), false),
            buildTab('following', followingCount.toString(), true),
            buildTab('subscriptions', '0', false),
            buildTab('Flagged', '', false),
          ],
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _FollowingListItem extends StatelessWidget {
  final User user;

  const _FollowingListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(user.profileImagePath),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.userNickName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.userName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Message',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.more_vert,
            size: 20,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}