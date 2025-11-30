import 'package:flutter/material.dart';

class ProfileEditPopup1 extends StatelessWidget {
  const ProfileEditPopup1({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 상단 이미지
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Image.asset(
              'assets/images/other_images/friends.jpg', // ← 여기만 네 실제 경로로 변경
              fit: BoxFit.contain,
            ),
          ),

          // 타이틀
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Create your avatar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 서브텍스트
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Get your own personalized\nstickers to share in stories and\nchats.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),

          // "Create avatar"
          InkWell(
            onTap: () {
              // TODO: 아바타 생성 화면으로 이동 등
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'Create avatar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF385898),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE0E0E0)),

          // "Not now"
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Center(
                child: Text(
                  'Not now',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 편하게 부르는 helper
Future<void> showProfileEditPopup1(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const ProfileEditPopup1(),
  );
}