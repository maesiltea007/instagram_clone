import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_users.dart';

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
    // 사진 1장일 때는 카운터 없어야 함
    if (post.mediaPaths.length == 1) {
      return AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          post.mediaPaths.first,
          fit: BoxFit.cover,
        ),
      );
    }

    return AspectRatio(
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }

  Widget _buildPageIndicator(int length) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(length, (index) {
        final bool isActive = index == _currentPage;
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.blueGrey.shade900 : Colors.grey.shade400,
          ),
        );
      }),
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