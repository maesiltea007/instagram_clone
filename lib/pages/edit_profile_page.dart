import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/widgets/profile_edit/profile_edit_pop_up_1.dart';

class EditProfilePage extends StatefulWidget {
  final User user; // ★ 프로필 정보

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 앱 실행 중에 이 페이지에서 팝업을 이미 한 번 보여줬는지
  static bool _hasShownPopup = false;

  @override
  void initState() {
    super.initState();

    // 처음 진입한 경우에만 팝업
    if (!_hasShownPopup) {
      _hasShownPopup = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showProfileEditPopup1(context);
      });
    }
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
                      CircleAvatar(
                        radius: 40,
                        // ★ 실제 유저 프로필 이미지
                        backgroundImage: AssetImage(
                          widget.user.profileImagePath,
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
                const Text(
                  'Change profile picture',
                  style: TextStyle(
                    color: Color(0xFF385898),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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