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
      return VideoPostCard(
        post: post,
        onCommentTap: onCommentTap,
      );
    }

    return ImagePostCard(
      post: post,
      onCommentTap: onCommentTap,
    );
  }
}