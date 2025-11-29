import 'package:flutter/material.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_dm_threads.dart';
import 'package:instagram/models/dm_thread.dart';
import 'package:instagram/pages/dm_message_page.dart';

class DmListPage extends StatelessWidget {
  const DmListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 현재 로그인 유저
    final me = currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        foregroundColor: Colors.black,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const SizedBox(width: 8),
            Text(
              me.userNickName,
              style: const TextStyle(
                fontSize: 20,
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
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // 검색바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
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
          ),

          const SizedBox(height: 16),

          // "Your note" 영역 (상단 스토리 느낌)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage:
                            AssetImage(me.profileImagePath),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Your note',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Text(
                          "What's on\nyour playlist?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // "Messages" 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: const [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.notifications_off_outlined,
                  size: 14,
                ),
                Spacer(),
                Text(
                  'Requests (1)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // DM Thread 리스트
          ...dummyDmThreads.map(
                (thread) => _buildThreadTile(context, thread),
          ),

          const SizedBox(height: 24),

          // Find friends 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Find friends to follow and message',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildSuggestionRow(
            title: 'Connect contacts',
            subtitle: 'Follow people you know.',
            buttonText: 'Connect',
          ),
          _buildSuggestionRow(
            title: 'Search for friends',
            subtitle: "Find your friends' accounts.",
            buttonText: 'Search',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ───────── DM Thread 하나 row ─────────
  Widget _buildThreadTile(BuildContext context, DmThread thread) {
    final peer = usersById[thread.peerUserId];
    final subtitle = thread.isSeen
        ? 'Seen'
        : 'Sent ${_timeAgo(thread.lastMessageTime)} ago';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(peer?.profileImagePath ?? ''),
      ),
      title: Text(
        peer?.userName ?? '',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(Icons.camera_alt_outlined, size: 20),
      onTap: () {
        // 여기서 DM 채팅 페이지로 이동 (애니메이션 없음)
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DmMessagePage(thread: thread),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
    );
  }

  // ───────── 하단 추천 row (Connect / Search) ─────────
  Widget _buildSuggestionRow({
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          ),
          const SizedBox(width: 12),
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
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF1877F2),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: const Size(0, 0),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ───────── time ago helper (3m, 2w 등) ─────────
  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) {
      final s = diff.inSeconds <= 0 ? 1 : diff.inSeconds;
      return '${s}s';
    }
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7}w';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30}mo';
    return '${diff.inDays ~/ 365}y';
  }
}