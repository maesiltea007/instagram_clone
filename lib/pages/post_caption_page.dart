import 'package:flutter/material.dart';
import '../data/dummy_posts.dart';
import '../models/post.dart';
import '../widgets/create_post/post_caption_bottom_sheet2.dart';
import '../widgets/create_post/post_caption_bottom_sheet_1.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/pages/instagram_main.dart';

class PostCaptionPage extends StatefulWidget {
  final String imagePath;
  const PostCaptionPage({
    super.key,
    required this.imagePath,
  });

  @override
  State<PostCaptionPage> createState() => _PostCaptionPageState();
}

class _PostCaptionPageState extends State<PostCaptionPage> {
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 화면 들어오자마자 한 번만 바텀시트 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCaptionBottomSheet();
    });
  }

  void _uploadPost() {
    final caption = _captionController.text.trim();

    final newPost = Post(
      id: '0',
      authorid: currentUser.id,
      caption: caption,
      mediaPaths: [widget.imagePath],
      isVideo: false,
      likeCount: 0,
      createdAt: DateTime.now(),
    );

    upsertUserPost(newPost);

    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => InstagramMain(
          title: 'Instagram',
          initialIndex: 4, // 프로필 탭
        ),
        transitionDuration: Duration.zero,        // ← 슬라이드 제거
        reverseTransitionDuration: Duration.zero, // ← 뒤로 갈 때도 제거
      ),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _showCaptionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const PostCaptionBottomSheet1(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // 위쪽 내용 스크롤
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // ───── 이미지 + 캡션 (세로 배치) ─────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 160,
                            height: 160,
                            color: Colors.grey.shade200,
                            child: Image.asset(
                              widget.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _captionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Add a caption...',
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ───── Poll / Prompt 버튼 ─────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _chipButton(
                          icon: Icons.bar_chart_rounded,
                          label: 'Poll',
                          onTap: () {},
                        ),
                        const SizedBox(width: 8),
                        _chipButton(
                          icon: Icons.search,
                          label: 'Prompt',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 얇은 divider (caption 영역 아래 딱 한 줄)
                  _thinDivider(),

                  // ───── Tag people / Add location ─────
                  _menuTile(
                    icon: Icons.person_outline,
                    title: 'Tag people',
                    onTap: () {},
                  ),
                  _menuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Add location',
                    subtitle:
                    'People you share this content with can see the location you tag and view this content on the map.',
                    onTap: () {},
                  ),

                  // 굵은 divider (Add location 아래 한 번)
                  _thickDivider(),

                  // ───── Audience / Also share on… / More options ─────
                  _menuTile(
                    icon: Icons.remove_red_eye_outlined,
                    title: 'Audience',
                    trailingText: 'Everyone',
                    onTap: () {},
                  ),

                  // 얇은 divider (Audience와 Also share 사이 한 줄)
                  _thinDivider(),

                  _menuTile(
                    icon: Icons.open_in_new_outlined,
                    title: 'Also share on...',
                    trailingText: 'Off',
                    trailingNewBadge: true,
                    onTap: () {},
                  ),

                  // 굵은 divider (Also share 아래 한 번)
                  _thickDivider(),

                  _menuTile(
                    icon: Icons.more_horiz,
                    title: 'More options',
                    onTap: () {},
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ───── 아래 Share 버튼 고정 ─────
          SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 44,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: false,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (sheetCtx) => PostCaptionBottomSheet2(
                        onOk: () {
                          Navigator.of(sheetCtx).pop(); // bottom sheet 닫기
                          _uploadPost();                // 업로드 + 화면 전환
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── helpers ─────────────────

  Widget _thinDivider() {
    return Divider(
      height: 1,
      thickness: 0.7,
      color: Colors.grey.shade300,
    );
  }

  // 인스타에서 섹션 사이 회색 띠처럼 보이게
  Widget _thickDivider() {
    return Container(
      height: 10,
      color: Colors.grey.shade200,
    );
  }

  Widget _chipButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        backgroundColor: const Color(0xFFF3F3F3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.black87),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailingText,
    bool trailingNewBadge = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: subtitle != null
          ? Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
      )
          : null,
      trailing: trailingText == null
          ? const Icon(Icons.chevron_right)
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailingText,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          if (trailingNewBadge) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}