import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';

import 'image_post_card.dart';
import 'video_post_card.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onCommentTap;

  const PostCard({
    super.key,
    required this.post,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (post.isVideo) {
      // 비디오 전용 카드 (지금은 TODO 상태)
      return VideoPostCard(
        post: post,
        onCommentTap: onCommentTap,
      );
    }

    // 이미지 전용 카드
    return ImagePostCard(
      post: post,
      onCommentTap: onCommentTap,
    );
  }
}