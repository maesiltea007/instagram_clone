import 'package:flutter/material.dart';

class PostCaptionBottomSheet1 extends StatelessWidget {
  const PostCaptionBottomSheet1({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 위에 짧은 바
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Sharing posts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            _infoRow(
              icon: Icons.person_add_alt_outlined,
              text:
              'Your account is public, so anyone can discover your posts and follow you.',
            ),
            const SizedBox(height: 16),
            _infoRow(
              icon: Icons.repeat,
              text:
              'Anyone can reuse all or part of your post in features like remixes, sequences, templates and stickers, and download your post as part of their reel or post.',
            ),
            const SizedBox(height: 16),
            _infoRow(
              icon: Icons.settings_outlined,
              text:
              'You can turn off reuse for each post or change the default in your settings.',
            ),

            const SizedBox(height: 24),

            // OK 버튼
            SizedBox(
              height: 44,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
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
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: settings 이동 (지금은 더미)
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
            ),

            const SizedBox(height: 4),

            // Learn more 문구
            const Center(
              child: Text(
                'Learn more in the Help Center.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _infoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Icon(
            icon,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
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