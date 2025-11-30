import 'package:flutter/material.dart';
import 'package:instagram/data/dummy_posts.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/widgets/comment/comment_bottom_sheet.dart';
import 'package:instagram/pages/instagram_main.dart'; // <- 경로는 너 프로젝트에 맞게

class OnlyOnePostPage extends StatefulWidget {
  final String postId;
  final bool autoOpenComments;

  const OnlyOnePostPage({
    super.key,
    required this.postId,
    this.autoOpenComments = false,
  });

  @override
  State<OnlyOnePostPage> createState() => _OnlyOnePostPageState();
}

class _OnlyOnePostPageState extends State<OnlyOnePostPage> {
  Post? post;

  @override
  void initState() {
    super.initState();

    // 포스트 로드 (못 찾으면 null 처리)
    try {
      post = dummyPosts.firstWhere((p) => p.id == widget.postId);
    } catch (_) {
      post = null;
    }

    // 화면 완성 후 bottom sheet 자동 오픈
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.autoOpenComments && post != null) {
        _openComments();
      }
    });
  }

  void _openComments() {
    if (post == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsBottomSheet(post: post!),
    );
  }

  void _goToTab(int index) {
    // InstagramMain을 해당 탭 인덱스로 다시 띄우면서
    // 기존 라우트 스택 싹 정리
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => InstagramMain(
          title: 'Instagram',
          initialIndex: index,
        ),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (post == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Photo"),
        ),
        body: const Center(child: Text("Post not found")),
      );
    }

    final user = usersById[post!.authorid];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Photo",
          style: TextStyle(color: Colors.black),
        ),
      ),

      // ───────── BODY ─────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(
                    user?.profileImagePath ??
                        "assets/images/profile_images/default_user_image.jpg",
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  user?.userNickName ?? "unknown",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // 게시물 이미지
          Expanded(
            child: Center(
              child: Image.asset(
                post!.mediaPaths.first,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),

      // ───────── BOTTOM BAR ─────────
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _goToTab(0),
                child: Container(
                  color: Colors.transparent,
                  height: 48,
                  child: const Center(
                    child: Icon(Icons.home),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _goToTab(1),
                child: Container(
                  color: Colors.transparent,
                  height: 48,
                  child: const Center(
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _goToTab(2),
                child: Container(
                  color: Colors.transparent,
                  height: 48,
                  child: const Center(
                    child: Icon(Icons.add_box_outlined),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _goToTab(3),
                child: Container(
                  color: Colors.transparent,
                  height: 48,
                  child: const Center(
                    child: Icon(Icons.smart_display_outlined),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => _goToTab(4),
                child: Container(
                  color: Colors.transparent,
                  height: 48,
                  child: Center(
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage:
                      AssetImage(currentUser.profileImagePath),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}