import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';

class PostFooter extends StatelessWidget {
  final Post post;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onToggleLike;
  final VoidCallback? onCommentTap;

  // 여러 장일 때만 쓰는 인디케이터 옵션
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 액션 + 가운데 인디케이터
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

        // likes
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

        // 날짜 (예: "5 days ago")
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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

    if (diff.inDays >= 365) {
      final years = diff.inDays ~/ 365;
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (diff.inDays >= 30) {
      final months = diff.inDays ~/ 30;
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (diff.inDays >= 7) {
      final weeks = diff.inDays ~/ 7;
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (diff.inDays >= 1) {
      final days = diff.inDays;
      return days == 1 ? '1 day ago' : '$days days ago';
    } else if (diff.inHours >= 1) {
      final hours = diff.inHours;
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    } else if (diff.inMinutes >= 1) {
      final mins = diff.inMinutes;
      return mins == 1 ? '1 minute ago' : '$mins minutes ago';
    } else {
      return 'Just now';
    }
  }
}