import 'package:flutter/material.dart';

class ChangeNamePopUp extends StatelessWidget {
  final String newName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ChangeNamePopUp({
    super.key,
    required this.newName,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),

          // 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Are you sure you want to change your name to\n$newName?",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 설명
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "You can only change your name twice within 14 days.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Change name 버튼
          InkWell(
            onTap: onConfirm,
            child: Container(
              alignment: Alignment.center,
              height: 48,
              child: const Text(
                "Change name",
                style: TextStyle(
                  color: Color(0xFF3897F0),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE0E0E0)),

          // Cancel 버튼
          InkWell(
            onTap: onCancel,
            child: Container(
              alignment: Alignment.center,
              height: 48,
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}