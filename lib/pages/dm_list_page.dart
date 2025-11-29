// lib/pages/dm_list_page.dart
import 'package:flutter/material.dart';
import 'package:instagram/data/dummy_dm_threads.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/models/dm_thread.dart';

class DmListPage extends StatelessWidget {
  const DmListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildYourNote(),
          const SizedBox(height: 16),
          _buildMessagesHeader(),
          Expanded(
            child: ListView(
              children: [
                ...dummyDmThreads.map(_buildThreadTile),
                const SizedBox(height: 24),
                _buildFindFriendsSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────── AppBar ─────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
      titleSpacing: 0,
      centerTitle: false,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            currentUser.userNickName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 20,
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            // TODO: 새 메시지 작성
          },
        ),
      ],
    );
  }

  // ───────── 검색 바 ─────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        child: const Row(
          children: [
            Icon(Icons.search, size: 20, color: Colors.grey),
            SizedBox(width: 6),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────── 상단 Your note ─────────
  Widget _buildYourNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage:
                    AssetImage(currentUser.profileImagePath),
                  ),
                  Positioned(
                    left: 40,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text(
                        "What's on your playlist?",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your note',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Messages 헤더 ─────────
  Widget _buildMessagesHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.notifications_off_outlined,
            size: 16,
            color: Colors.grey,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              // TODO: Requests 이동
            },
            child: const Text(
              'Requests (1)',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── 쓰레드 타일 ─────────
  Widget _buildThreadTile(DmThread thread) {
    final peer = usersById[thread.peerUserId];

    final subtitle = thread.isSeen
        ? 'Seen'
        : 'Sent ${_timeAgo(thread.lastMessageTime)}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(peer?.profileImagePath ?? ''),
      ),
      title: Text(
        peer?.userNickName ?? 'unknown',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.camera_alt_outlined,
        size: 20,
        color: Colors.grey,
      ),
      onTap: () {
        // TODO: DM 채팅 페이지로 이동 (애니메이션 없이)
      },
    );
  }

  // ───────── 하단 Find friends 섹션 ─────────
  Widget _buildFindFriendsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Find friends to follow and message',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          _promoRow(
            icon: Icons.person_outline,
            title: 'Connect contacts',
            subtitle: 'Follow people you know.',
            buttonText: 'Connect',
          ),
          const SizedBox(height: 12),
          _promoRow(
            icon: Icons.search,
            title: 'Search for friends',
            subtitle: "Find your friends' accounts.",
            buttonText: 'Search',
          ),
        ],
      ),
    );
  }

  Widget _promoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Icon(icon, size: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {},
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.close,
            size: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  // ───────── timeAgo 헬퍼 (3m / 2w 같은 용도) ─────────
  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);

    if (diff.inMinutes < 1) {
      final s = diff.inSeconds;
      return '${s <= 0 ? 1 : s}s';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes}m';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours}h';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d';
    }
    if (diff.inDays < 30) {
      return '${diff.inDays ~/ 7}w';
    }
    if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30}mo';
    }
    return '${diff.inDays ~/ 365}y';
  }
}