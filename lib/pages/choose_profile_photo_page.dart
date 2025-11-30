import 'package:flutter/material.dart';

class ChooseProfilePhotoPage extends StatefulWidget {
  final List<String> imagePaths;

  const ChooseProfilePhotoPage({
    super.key,
    this.imagePaths = const [
      'assets/dummy_device/images/puang_happy.jpg',
    ],
  });

  @override
  State<ChooseProfilePhotoPage> createState() => _ChooseProfilePhotoPageState();
}

class _ChooseProfilePhotoPageState extends State<ChooseProfilePhotoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
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
            "Recents",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          centerTitle: false,
        ),
        body: const Center(
          child: Text(
            'No images',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    final selectedImage = widget.imagePaths[_selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white,        // ← 흰 배경
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Recents",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedImage);
            },
            child: const Text(
              "Done",
              style: TextStyle(
                color: Color(0xFF3897F0),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // ================== 상단 원형 미리보기 ==================
          Expanded(
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  selectedImage,
                  fit: BoxFit.cover,      // 원형 크롭
                  width: 260,
                  height: 260,
                ),
              ),
            ),
          ),

          // Divider
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE0E0E0),
          ),

          // ================== 하단 썸네일 ==================
          Container(
            height: 110,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                final img = widget.imagePaths[index];
                final selected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = index);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected ? const Color(0xFF3897F0) : Colors.transparent,
                        width: 2,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                    child: Image.asset(
                      img,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}