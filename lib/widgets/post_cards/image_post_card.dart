import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';
import 'post_footer.dart';

class ImagePostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onCommentTap;

  const ImagePostCard({
    super.key,
    required this.post,
    this.onCommentTap,
  });

  @override
  State<ImagePostCard> createState() => _ImagePostCardState();
}

class _ImagePostCardState extends State<ImagePostCard> {
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
    final hasMultiple = post.mediaPaths.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(post),
        _buildMedia(post),
        PostFooter(
          post: post,
          isLiked: _isLiked,
          likeCount: _likeCount,
          onToggleLike: _toggleLike,
          onCommentTap: widget.onCommentTap,
          showIndicator: hasMultiple,
          currentPage: _currentPage,
          totalPages: post.mediaPaths.length,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildHeader(Post post) {
    final user = usersById[post.authorid];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: CircleAvatar(
        radius: 18,
        backgroundImage:
        user != null ? AssetImage(user.profileImagePath) : null,
        backgroundColor: Colors.grey,
      ),
      title: Text(
        user?.userNickName ?? 'unknown',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.more_vert),
    );
  }

  Widget _buildMedia(Post post) {
    // 사진 1장
    if (post.mediaPaths.length == 1) {
      return GestureDetector(
        onDoubleTap: _toggleLike,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            post.mediaPaths.first,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    // 사진 여러 장
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: post.mediaPaths.length,
              onPageChanged: (idx) {
                setState(() => _currentPage = idx);
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  post.mediaPaths[index],
                  fit: BoxFit.cover,
                );
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentPage + 1}/${post.mediaPaths.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }
}