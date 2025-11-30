import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/data/dummy_users.dart';

class PostPopUp extends StatefulWidget {
  final Post post;
  final VoidCallback? onDismissed; // reverse 애니메이션 끝나면 overlay 제거용

  const PostPopUp({
    super.key,
    required this.post,
    this.onDismissed,
  });

  @override
  State<PostPopUp> createState() => _PostPopUpState();
}

class _PostPopUpState extends State<PostPopUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 120),
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInBack,
    );

    _controller.forward();
  }

  // 손 떼면 reverse 애니메이션
  void dismiss() async {
    await _controller.reverse();
    widget.onDismissed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final User? author = usersById[widget.post.authorid];

    return GestureDetector(
      onTap: dismiss, // 팝업 바깥 누를 때 닫힘
      child: Material(
        color: Colors.black.withOpacity(0.45),
        child: Center(
          child: ScaleTransition(
            scale: _scale,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 상단 프로필 영역
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: author != null
                              ? AssetImage(author.profileImagePath)
                              : null,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            author?.userNickName ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 게시물 이미지
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Image.asset(
                      widget.post.mediaPaths.first,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // 하단 아이콘들 – 균등 분포
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.favorite_border, size: 24),
                        Icon(Icons.mode_comment_outlined, size: 24),
                        Icon(Icons.send_outlined, size: 24),
                        Icon(Icons.bookmark_border, size: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}