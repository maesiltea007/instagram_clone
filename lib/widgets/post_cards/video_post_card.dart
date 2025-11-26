import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';
import 'post_footer.dart';

class VideoPostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onCommentTap;

  const VideoPostCard({
    super.key,
    required this.post,
    this.onCommentTap,
  });

  @override
  State<VideoPostCard> createState() => _VideoPostCardState();
}

class _VideoPostCardState extends State<VideoPostCard> {
  late VideoPlayerController _controller;
  bool _isMuted = true;

  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();

    _isLiked = false;
    _likeCount = widget.post.likeCount;

    _controller = VideoPlayerController.asset(widget.post.mediaPaths.first)
      ..initialize().then((_) {
        setState(() {});
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  void _toggleMute() {
    _isMuted = !_isMuted;
    _controller.setVolume(_isMuted ? 0 : 1);
    setState(() {});
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final user = usersById[post.authorid];

    // 로딩 중일 때도 6:7 비율 유지
    if (!_controller.value.isInitialized) {
      return const AspectRatio(
        aspectRatio: 6 / 7,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───────── 영상 영역 ─────────
        AspectRatio(
          aspectRatio: 6 / 7,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: _togglePlay,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),

                // 좌측 상단 프로필
                Positioned(
                  top: 12,
                  left: 12,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: user != null
                            ? AssetImage(user.profileImagePath)
                            : null,
                        backgroundColor: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user?.userNickName ?? 'unknown',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 일시정지 시 중앙 플레이 아이콘
                if (!_controller.value.isPlaying)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black38,
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),

                // 우측 하단 음소거 버튼
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleMute,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ───────── 이미지 포스트와 같은 Footer (공통) ─────────
        PostFooter(
          post: post,
          isLiked: _isLiked,
          likeCount: _likeCount,
          onToggleLike: _toggleLike,
          onCommentTap: widget.onCommentTap,
          showIndicator: false, // 비디오는 인디케이터 없음
          currentPage: 0,
          totalPages: 0,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}