import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';

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

        // ───────── 이미지 포스트와 같은 영역들 ─────────
        _buildActions(),
        _buildLikes(),
        _buildCaption(post),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildActions() {
    final post = widget.post;
    final hasMultiple = post.mediaPaths.length > 1;

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : null,
              ),
              onPressed: _toggleLike,
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: widget.onCommentTap ?? () {},
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

        // 여러 장일 때만 가운데 인디케이터
        if (hasMultiple)
          IgnorePointer(
            ignoring: true,
            child: _buildPageIndicator(post.mediaPaths.length),
          ),
      ],
    );
  }

  // 비디오도 혹시 여러 개 붙이는 경우 대비해서 그대로 둠
  Widget _buildPageIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        // 이 클래스에서는 _currentPage 없으니까
        // 전부 흐릿하게만 두거나, 필요하면 나중에 상태 추가해서 맞춰라.
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade400,
          ),
        );
      }),
    );
  }

  Widget _buildLikes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '$_likeCount likes',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCaption(Post post) {
    final user = usersById[post.authorid];

    return Padding(
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
    );
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likeCount -= 1;
      } else {
        _isLiked = true;
        _likeCount += 1;
      }
    });
  }
}