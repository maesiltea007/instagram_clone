import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_comments.dart';

class PostFooter extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onToggleLike;
  final VoidCallback? onCommentTap;

  final bool showIndicator;
  final int currentPage;
  final int totalPages;

  const PostFooter({
    super.key,
    required this.post,
    required this.isLiked,
    required this.likeCount,
    required this.onToggleLike,
    this.onCommentTap,
    this.showIndicator = false,
    this.currentPage = 0,
    this.totalPages = 0,
  });

  @override
  Widget build(BuildContext context) {
    final user = usersById[post.authorid];
    final hasMultiple = showIndicator && totalPages > 1;

    final comments = commentsByPostId[post.id] ?? [];
    final topComment = comments.isNotEmpty ? comments.first : null;
    final topUser =
    topComment != null ? usersById[topComment.authorId] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Action bar + indicator
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: onToggleLike,
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: onCommentTap ?? () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ],
            ),
            if (hasMultiple)
              IgnorePointer(
                ignoring: true,
                child: _buildPageIndicator(),
              ),
          ],
        ),

        // Likes count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$likeCount likes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: user?.userNickName ?? 'unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '  '),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ),

        if (topComment != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 댓글 텍스트
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: topUser?.userNickName ?? 'unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(text: topComment.text),
                      ],
                    ),
                  ),
                ),

                // 오른쪽 하트 아이콘 (더미)
                Icon(
                  Icons.favorite_border,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),

        // Date
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            _timeAgo(post.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        final active = index == currentPage;
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.black : Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays >= 365) return '${diff.inDays ~/ 365} years ago';
    if (diff.inDays >= 30) return '${diff.inDays ~/ 30} months ago';
    if (diff.inDays >= 7) return '${diff.inDays ~/ 7} weeks ago';
    if (diff.inDays >= 1) return '${diff.inDays} days ago';
    if (diff.inHours >= 1) return '${diff.inHours} hours ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} minutes ago';
    return 'Just now';
  }
}