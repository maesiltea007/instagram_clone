import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/widgets/profile_edit/profile_edit_pop_up_1.dart';
import 'package:instagram/widgets/profile_edit/profile_photo_bottom_sheet.dart';
import 'package:instagram/data/dummy_users.dart'; // currentUser, usersById

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  static bool _hasShownPopup = false;

  late String _profileImagePath; // 현재 페이지에서 쓰는 프로필 이미지 경로

  @override
  void initState() {
    super.initState();

    _profileImagePath = widget.user.profileImagePath;

    if (!_hasShownPopup) {
      _hasShownPopup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showProfileEditPopup1(context);
      });
    }
  }

  void _openProfilePhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ProfilePhotoBottomSheet(
        profileImagePath: _profileImagePath,
        onImageSelected: (newPath) {
          setState(() {
            _profileImagePath = newPath;

            // ★ 실제 더미 데이터 직접 수정 (copyWith 제거 버전)
            currentUser.profileImagePath = newPath;

            final user = usersById[currentUser.id];
            if (user != null) {
              user.profileImagePath = newPath;
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.4,
        title: const Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 12),

          // PROFILE PHOTO
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 84,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _openProfilePhotoSheet,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(_profileImagePath),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD8D8D8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _openProfilePhotoSheet,
                  child: const Text(
                    'Change profile picture',
                    style: TextStyle(
                      color: Color(0xFF385898),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          _buildFieldBlock("Name", "puang"),
          _buildFieldBlock("Username", "ta_junhyuk"),
          _buildFieldBlock("Pronouns", ""),
          _buildFieldBlock("Bio", "I’m gonna be the God of Flutter!"),

          _buildSectionItem("Add link"),
          _buildSectionItem("Add banners"),

          _buildFieldTitle("Gender"),
          _buildSectionItemWithArrow("Prefer not to say"),

          _buildSectionItemWithTrailing(
            "Music",
            trailing: "Add music to your profile",
          ),

          const SizedBox(height: 10),

          _buildBigButton("Switch to professional account"),
          _buildDivider(),
          _buildBigButton("Personal information settings"),
          _buildDivider(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ================== helpers ==================

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildFieldBlock(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldTitle(title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: Divider(
            height: 1,
            thickness: 0.5,
            color: Color(0xFFE0E0E0),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      color: Color(0xFFE0E0E0),
    );
  }

  Widget _buildSectionItem(String text) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildSectionItemWithArrow(String text) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildSectionItemWithTrailing(
      String text, {
        required String trailing,
      }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                Text(
                  trailing,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildDivider(),
      ],
    );
  }

  Widget _buildBigButton(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF385898),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}