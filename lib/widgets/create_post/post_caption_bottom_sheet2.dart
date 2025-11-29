// lib/widgets/create_post/post_caption_bottom_sheet_2.dart
import 'package:flutter/material.dart';

class PostCaptionBottomSheet2 extends StatelessWidget {
  /// OK 눌렀을 때 실행할 콜백 (업로드 로직은 나중에 여기서 호출)
  final VoidCallback onOk;

  const PostCaptionBottomSheet2({
    super.key,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 위에 조그만 바
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999),
              ),
            ),

            // 제목
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Sharing posts',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 항목 1
            _bulletRow(
              icon: Icons.person_add_alt_outlined,
              title: 'Your account is public, so anyone can discover your posts and follow you.',
            ),
            const SizedBox(height: 12),

            // 항목 2
            _bulletRow(
              icon: Icons.sync_alt_outlined,
              title:
              'Anyone can reuse all or part of your post in features like remixes, sequences, templates and stickers, and download your post as part of their reel or post.',
            ),
            const SizedBox(height: 12),

            // 항목 3
            _bulletRow(
              icon: Icons.settings_outlined,
              title:
              'You can turn off reuse for each post or change the default in your settings.',
            ),

            const SizedBox(height: 24),

            // OK 버튼
            SizedBox(
              width: double.infinity,
              height: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  onOk();
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Manage settings
            TextButton(
              onPressed: () {
                // TODO: 설정 화면으로 이동 (지금은 더미)
              },
              child: const Text(
                'Manage settings',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Learn more
            const Text(
              'Learn more in the Help Center.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletRow({
    required IconData icon,
    required String title,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}