import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/widgets/profile_edit/profile_edit_pop_up_1.dart';
import 'package:instagram/widgets/profile_edit/profile_photo_bottom_sheet.dart';
import 'package:instagram/data/dummy_users.dart'; // currentUser, usersById
import 'package:instagram/pages/change_name_page.dart';
import 'package:instagram/pages/change_bio_page.dart'; // ★ 추가

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

  late String _profileImagePath;
  bool _changed = false; // ★ 여기: 뭔가 수정했는지 여부

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

  // ───────── 프로필 사진 바텀시트 ─────────
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
            _changed = true; // ★ 변경됨 표시

            // 더미 데이터 직접 수정
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

  // ───────── Name 수정 페이지 ─────────
  Future<void> _openChangeNamePage(User user) async {
    final newName = await Navigator.of(context).push<String>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChangeNamePage(user: user),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        // ChangeNamePage 안에서 user.userName, 더미 데이터 이미 수정됨
        _changed = true; // ★ 이름 바뀜
      });
    }
  }

  // ───────── Bio 수정 페이지 ─────────
  Future<void> _openChangeBioPage(User user) async {
    final newBio = await Navigator.of(context).push<String>(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChangeBioPage(user: user),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

    if (newBio != null) {
      setState(() {
        // ChangeBioPage 안에서 user.bio, 더미 데이터 이미 수정됨
        _changed = true; // ★ bio 바뀜
      });
    }
  }

  Future<bool> _onWillPop() async {
    // 뒤로가기 / 제스처로 나갈 때도 변경 여부 넘겨주기
    Navigator.of(context).pop(_changed);
    return false; // 우리가 직접 pop 했으니 기본 pop 막기
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.4,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_changed); // ★ AppBar 뒤로가기도 결과 반환
            },
          ),
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

            // ───────── PROFILE PHOTO ─────────
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

            // ───────── 실제 유저 정보 필드 ─────────
            _buildFieldBlock(
              "Name",
              user.userName,
              onTap: () => _openChangeNamePage(user),
            ),
            _buildFieldBlock("Username", user.userNickName),
            _buildFieldBlock("Pronouns", ""),
            _buildFieldBlock(
              "Bio",
              user.bio,
              onTap: () => _openChangeBioPage(user),
            ),

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

  /// 한 줄 전체 터치 가능 필드
  Widget _buildFieldBlock(
      String title,
      String text, {
        VoidCallback? onTap,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldTitle(title),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 0),
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