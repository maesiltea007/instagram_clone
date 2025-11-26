import 'package:flutter/material.dart';

import '../../pages/post_page.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),

          // 위에 있는 짧은 바
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 12),

          // Create 제목
          const Text(
            'Create',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          // 긴 Divider
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),

          // Reel
          _buildItem(
            icon: Icons.videocam_outlined,
            label: 'Reel',
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // 짧은 Divider
          Padding(
            padding: const EdgeInsets.only(left: 56), // 아이콘+여백 만큼 패딩
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),

          // Post
          _buildItem(
            icon: Icons.grid_on_outlined,
            label: 'Post',
            onTap: () {
              Navigator.pop(context); // 바텀시트 닫고
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PostPage(),
                ),
              );
            },
          ),

          // 짧은 Divider
          Padding(
            padding: const EdgeInsets.only(left: 56),
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),

          // Share only to profile
          _buildItem(
            icon: Icons.grid_3x3_outlined,
            label: 'Share only to profile',
            trailing: _buildNewBadge(),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          // 아래 흰 여백
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      onTap: onTap,
      minLeadingWidth: 0,
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.shade500,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'New',
        style: TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}