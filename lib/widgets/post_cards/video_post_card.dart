import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';

class VideoPostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onCommentTap;

  const VideoPostCard({
    super.key,
    required this.post,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildVideoPostCard();
  }

  Widget _buildVideoPostCard() {
    // TODO: 여기서 실제 비디오 플레이어 UI 구현하기
    return AspectRatio(
      aspectRatio: 1, // 일단 정사각형 박스
      child: Container(
        color: Colors.black12,
        child: const Center(
          child: Text(
            'VideoPostCard TODO',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}