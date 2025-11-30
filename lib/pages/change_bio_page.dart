import 'package:flutter/material.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/data/dummy_users.dart'; // currentUser, usersById

class ChangeBioPage extends StatefulWidget {
  final User user;

  const ChangeBioPage({
    super.key,
    required this.user,
  });

  @override
  State<ChangeBioPage> createState() => _ChangeBioPageState();
}

class _ChangeBioPageState extends State<ChangeBioPage> {
  static const int _maxBioLength = 150;

  late TextEditingController _controller;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.user.bio);
    _remaining = _maxBioLength - _controller.text.length;

    _controller.addListener(() {
      setState(() {
        _remaining = _maxBioLength - _controller.text.length;
        if (_remaining < 0) _remaining = 0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDone() {
    final newBio = _controller.text;

    // 더미 데이터 업데이트
    widget.user.bio = newBio;

    if (currentUser.id == widget.user.id) {
      currentUser.bio = newBio;
    }

    final mapUser = usersById[widget.user.id];
    if (mapUser != null) {
      mapUser.bio = newBio;
    }

    Navigator.of(context).pop(newBio);
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
          'Bio',
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
              'Bio',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            TextField(
              controller: _controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                fontSize: 16,
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
            const SizedBox(height: 8),
            // 글자수(남은 글자) 오른쪽
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$_remaining',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),

            const Spacer(),

            // 하단 안내 문구
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    children: [
                      TextSpan(
                        text:
                        'Your bio is visible to everyone on and off Instagram. ',
                      ),
                      TextSpan(
                        text: 'Learn more',
                        style: TextStyle(
                          color: Color(0xFF385898),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}