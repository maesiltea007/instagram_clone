import 'package:flutter/material.dart';
import 'package:instagram/widgets/post_card.dart';
import 'package:instagram/data/dummy_posts.dart';

class InstagramMain extends StatefulWidget {
  const InstagramMain({super.key, required this.title});
  final String title;

  @override
  State<InstagramMain> createState() => _InstagramMainState();
}

class _InstagramMainState extends State<InstagramMain> {
  Widget _buildBottomTab(VoidCallback onTap, IconData icon) =>
      Expanded(
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(icon),
            ),
          ),
        ),
      );

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () {},
        ),
        elevation: 1,
        backgroundColor: Theme
            .of(context)
            .canvasColor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: dummyPosts.length,
        itemBuilder: (context, index) {
          final post = dummyPosts[index];
          return PostCard(
            post: post,
            onCommentTap: () {
              // 나중에 좋아요 등 기능 추가할 곳
            },
          );
        },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            _buildBottomTab(() {}, Icons.home),
            _buildBottomTab(() {}, Icons.search),
            _buildBottomTab(() {}, Icons.add_box),
            _buildBottomTab(() {}, Icons.favorite),
            _buildBottomTab(() {}, Icons.account_circle),
          ],
        ),
      ),
    );
  }
}