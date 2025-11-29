import 'package:flutter/material.dart';
import 'package:instagram/data/dummy_musics.dart';
import 'package:instagram/pages/post_caption_page.dart';

class PostEditPage extends StatelessWidget {
  final String imagePath;

  const PostEditPage({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // 상단 이미지 프리뷰
          Expanded(
            child: Center(
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 하단 음악 선택 + 버튼 줄
          _buildBottomControls(context),
        ],
      ),
    );
  }

  // ───────────────────────── AppBar ─────────────────────────
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      title: const SizedBox.shrink(),
      actions: [
        IconButton(
          icon: const Icon(Icons.auto_fix_high_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.link_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.image_outlined),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              const Text(
                'Aa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Positioned(
                top: 0,
                right: -14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'New',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  // ───────────────────────── 음악 + 버튼 영역 ─────────────────────────
  Widget _buildBottomControls(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black12, width: 1),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),

          // 음악 리스트
          _buildMusicList(),

          const SizedBox(height: 6),
          _buildBottomButtons(context),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ───────────────────────── 음악 리스트 ─────────────────────────
  Widget _buildMusicList() {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        itemCount: dummyMusics.length + 1, // Browse 포함
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Browse 타일
            return Column(
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.library_music_outlined),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Browse',
                  style: TextStyle(fontSize: 11),
                ),
              ],
            );
          }

          final music = dummyMusics[index - 1];

          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  music.albumCoverPath,
                  width: 74,
                  height: 74,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 80,
                child: Text(
                  music.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ───────────────────────── Edit / Next 버튼 ─────────────────────────
  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // Edit 버튼
          TextButton(
            style: TextButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: const Color(0xFFE0E0E0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            onPressed: () {},
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.black),
            ),
          ),

          const Spacer(),

          // Next 버튼
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostCaptionPage(
                    imagePath: imagePath,   // PostEditPage가 가지고 있는 이미지 경로를 전달
                  ),
                ),
              );
            },
            child: const Row(
              children: [
                Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}