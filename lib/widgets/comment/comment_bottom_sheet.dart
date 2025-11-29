import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_comments.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Post post;

  const CommentsBottomSheet({
    super.key,
    required this.post,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comments = commentsByPostId[widget.post.id] ?? [];

    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildDragHandle(),
            const SizedBox(height: 8),
            _buildHeader(),
            const Divider(height: 1),

            Expanded(
              child: comments.isEmpty
                  ? _buildEmptyComments()
                  : _buildCommentsList(comments),
            ),

            // 이모지 위 divider
            Divider(height: 1, color: Colors.grey.shade300),

            _buildEmojiRow(),
            _buildInputRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Comments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyComments() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Start the conversation.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(List comments) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final c = comments[index];
        final user = usersById[c.authorId];

        // 진짜 글쓴이인지 확인
        final bool isAuthor = c.authorId == widget.post.authorid;
        final String timeText = _timeAgoShort(c.createdAt);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(user?.profileImagePath ?? ''),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1줄: 아이디 + 시간 + (Author)
                    Row(
                      children: [
                        Text(
                          user?.userNickName ?? 'unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeText,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        if (isAuthor) ...[
                          const SizedBox(width: 4),
                          const Text(
                            '• Author',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 2),

                    // 2줄: 댓글 내용
                    Text(
                      c.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 3줄: Reply
                    const Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.favorite_border,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmojiRow() {
    const emojis = ['❤️', '🙌', '🔥', '👏', '🥲', '😍', '😮', '😂'];

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final e in emojis)
            Text(
              e,
              style: const TextStyle(fontSize: 24),
            ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    final me = currentUser;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(me.profileImagePath),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _controller.clear();
            },
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  // ───────── 시간 표시 헬퍼 (s / m / h / d / w / y) ─────────
  String _timeAgoShort(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) {
      final s = diff.inSeconds;
      return '${s <= 0 ? 1 : s}s';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    }
    if (diff.inHours < 24) {
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