import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/data/dummy_posts.dart';

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
            // 나중에 댓글 페이지로 이동 같은 거 넣을 자리
          },
        );
      },
    );
  }
}