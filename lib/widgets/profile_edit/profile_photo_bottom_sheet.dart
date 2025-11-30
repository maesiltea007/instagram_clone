import 'package:flutter/material.dart';
import 'package:instagram/pages/choose_profile_photo_page.dart';

class ProfilePhotoBottomSheet extends StatefulWidget {
  final String profileImagePath;              // 현재 프로필 이미지
  final ValueChanged<String>? onImageSelected; // 새 이미지 선택 콜백

  const ProfilePhotoBottomSheet({
    super.key,
    required this.profileImagePath,
    this.onImageSelected,
  });

  @override
  State<ProfilePhotoBottomSheet> createState() =>
      _ProfilePhotoBottomSheetState();
}

class _ProfilePhotoBottomSheetState extends State<ProfilePhotoBottomSheet> {
  int _selectedTab = 0; // 0: profile photo, 1: avatar

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            // 위 핸들
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),

            // 프로필 / 아바타 탭
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopTab(
                    index: 0,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(
                        widget.profileImagePath,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  _buildTopTab(
                    index: 1,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD8D8D8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),

            // 옵션 리스트
            _buildActionItem(
              icon: Icons.photo_library_outlined,
              label: 'Choose from library',
              onTap: () async {
                // 갤러리 페이지로 이동해서 결과(선택한 이미지 경로)를 받아옴
                final result = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => const ChooseProfilePhotoPage(
                      imagePaths: [
                        'assets/dummy_device/images/puang_happy.jpg',
                      ],
                    ),
                  ),
                );

                if (result != null) {
                  // 위로 콜백 전달
                  widget.onImageSelected?.call(result);
                }

                // bottom sheet 닫기
                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            _buildActionItem(
              icon: Icons.facebook,
              label: 'Import from Facebook',
              onTap: () {
                // TODO
                Navigator.pop(context);
              },
            ),
            _buildActionItem(
              icon: Icons.photo_camera_outlined,
              label: 'Take photo',
              onTap: () {
                // TODO
                Navigator.pop(context);
              },
            ),
            _buildActionItem(
              icon: Icons.delete_outline,
              label: 'Delete',
              isDestructive: true,
              onTap: () {
                // TODO
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 8),

            // 안내 문구
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'Your profile picture and avatar are visible to everyone on and off Instagram.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      // TODO: Learn more
                    },
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF385898),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTab({required int index, required Widget child}) {
    final bool selected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 2,
            color: selected ? Colors.black : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final Color textColor = isDestructive ? Colors.red : Colors.black87;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, size: 24, color: textColor),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
      ),
      onTap: onTap,
    );
  }
}