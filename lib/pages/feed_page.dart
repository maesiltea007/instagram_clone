import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_cards/post_card.dart';
import 'package:instagram/data/dummy_posts.dart';
import '../widgets/comment/comment_bottom_sheet.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyPosts.length,
      itemBuilder: (context, index) {
        final post = dummyPosts[index];
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
    );
  }
}