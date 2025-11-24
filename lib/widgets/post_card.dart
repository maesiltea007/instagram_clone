import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onCommentTap; // 댓글 버튼 눌렀을 때 동작 (페이지 이동 등)

  const PostCard({
    super.key,
    required this.post,
    this.onCommentTap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final PageController _pageController;
  int _currentPage = 0;

  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _isLiked = false;
    _likeCount = widget.post.likeCount;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(post),
        _buildMedia(post),
        _buildActions(),
        _buildLikes(),
        _buildCaption(post),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildHeader(Post post) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey,
      ),
      title: Text(
        post.username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.more_vert),
    );
  }

  Widget _buildMedia(Post post) {
    // 동영상 자리 (지금은 플레이 아이콘만) - 1:1 정사각형
    if (post.isVideo) {
      return AspectRatio(
        aspectRatio: 1, // 1:1
        child: Container(
          color: Colors.black12,
          child: const Center(
            child: Icon(
              Icons.play_arrow,
              size: 64,
            ),
          ),
        ),
      );
    }

    // 사진 1장 - 1:1 정사각형
    if (post.mediaUrls.length == 1) {
      return AspectRatio(
        aspectRatio: 1, // 1:1
        child: Image.network(
          post.mediaUrls.first,
          fit: BoxFit.cover,
        ),
      );
    }

    // 사진 여러 장 -> 가로 슬라이드 + 1:1
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1, // 1:1
          child: PageView.builder(
            controller: _pageController,
            itemCount: post.mediaUrls.length,
            onPageChanged: (idx) {
              setState(() => _currentPage = idx);
            },
            itemBuilder: (context, index) {
              return Image.network(
                post.mediaUrls[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_currentPage + 1}/${post.mediaUrls.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : null,
          ),
          onPressed: _toggleLike,
        ),
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: widget.onCommentTap ?? () {},
        ),
        IconButton(
          icon: const Icon(Icons.send_outlined),
          onPressed: () {},
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildLikes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '좋아요 $_likeCount개',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCaption(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: post.username,
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