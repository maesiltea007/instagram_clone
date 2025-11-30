import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/widgets/profile_edit/change_name_pop_up.dart';

class ChangeNamePage extends StatefulWidget {
  final User user;

  const ChangeNamePage({
    super.key,
    required this.user,
  });

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.user.userName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    final newName = _controller.text.trim();
    if (newName.isEmpty) {
      Navigator.pop(context);
      return;
    }

    // 1) 팝업에서 bool만 받아온다
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => ChangeNamePopUp(newName: newName),
    );

    // 취소 또는 바깥 눌러서 닫힌 경우
    if (confirmed != true) return;

    // 2) 실제 데이터 업데이트
    widget.user.userName = newName;

    if (currentUser.id == widget.user.id) {
      currentUser.userName = newName;
    }

    final mapUser = usersById[widget.user.id];
    if (mapUser != null) {
      mapUser.userName = newName;
    }

    // 3) 이전 페이지로 값 전달 (pop 한 번만)
    Navigator.of(context).pop(newName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Name',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _onDone,
            icon: const Icon(
              Icons.check,
              color: Color(0xFF3897F0),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            TextField(
              controller: _controller,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(top: 8, bottom: 4),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF3897F0),
                    width: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Help people discover your account by using the name you're known by: either your full name, nickname, or business name.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "You can only change your name twice within 14 days.",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text:
                    "Your name is visible to everyone on and off Instagram. ",
                  ),
                  TextSpan(
                    text: "Learn more",
                    style: TextStyle(
                      color: Color(0xFF385898),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}