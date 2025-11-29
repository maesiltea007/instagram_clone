import 'package:flutter/material.dart';

class AfterPostBottomSheet extends StatelessWidget {
  const AfterPostBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 위의 작은 바
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pause these messages?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 설명 텍스트
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "You'll stop seeing messages about sharing to Facebook for 90 days. "
                    "You can turn on crossposting when you share a story, post or reel.",
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Pause 버튼 (파란색)
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
                  // TODO: 90일 동안 pause 로직
                  Navigator.pop(context);
                },
                child: const Text(
                  'Pause',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // No thanks (파란 글자만)
            TextButton(
              onPressed: () {
                // 그냥 닫기
                Navigator.pop(context);
              },
              child: const Text(
                'No thanks',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}