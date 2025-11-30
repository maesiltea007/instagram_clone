import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_cards/post_card.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/pages/notifications_page.dart';
import 'package:instagram/pages/dm_list_page.dart';
import '../widgets/comment/comment_bottom_sheet.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ★ 피드에 보여줄 포스트만 필터링
    final feedPosts = dummyPosts.where((post) => post.showFeed).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: const Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const NotificationsPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const DmListPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: feedPosts.length,
        itemBuilder: (context, index) {
          final post = feedPosts[index];
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