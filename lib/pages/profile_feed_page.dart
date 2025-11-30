import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/widgets/post_cards/post_card.dart';
import 'package:instagram/widgets/comment/comment_bottom_sheet.dart';

class ProfileFeedPage extends StatefulWidget {
  final User targetUser;
  final int initialIndex;

  const ProfileFeedPage({
    super.key,
    required this.targetUser,
    required this.initialIndex,
  });

  @override
  State<ProfileFeedPage> createState() => _ProfileFeedPageState();
}

class _ProfileFeedPageState extends State<ProfileFeedPage> {
  late final List<Post> _posts;
  final ScrollController _scrollController = ScrollController();

  // 대략적인 PostCard 높이
  static const double estimatedPostCardHeight = 750;

  @override
  void initState() {
    super.initState();

    _posts = dummyPosts
        .where((post) => post.authorid == widget.targetUser.id)
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialIndex();
    });
  }

  void _scrollToInitialIndex() {
    if (_posts.isEmpty) return;

    final safeIndex =
    widget.initialIndex.clamp(0, _posts.length - 1);

    final offset = safeIndex * estimatedPostCardHeight;

    _scrollController.jumpTo(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Text(
              widget.targetUser.userNickName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.verified, color: Colors.blue, size: 18),
          ],
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return PostCard(
            post: post,
            onCommentTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CommentsBottomSheet(post: post),
              );
            },
          );
        },
      ),
    );
  }
}