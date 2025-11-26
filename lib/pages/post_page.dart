import 'package:flutter/material.dart';
import 'package:instagram/pages/post_edit_page.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // “디바이스 갤러리” 더미 이미지
  final List<String> _dummyDeviceImages = [
    'assets/dummy_device/images/puang_happy.jpg',
    'assets/dummy_device/images/video_preview.jpg',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasImage = _dummyDeviceImages.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: const [
            Text(
              'Recents',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final selectedImage = _dummyDeviceImages[_selectedIndex];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostEditPage(
                    imagePath: selectedImage,
                  ),
                ),
              );
            },
            child: const Text(
              'Next',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── 상단 프리뷰 (정사각형 + 오버레이) ───
          AspectRatio(
            aspectRatio: 1,
            child: hasImage
                ? Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  _dummyDeviceImages[_selectedIndex],
                  fit: BoxFit.cover,
                ),

                // 왼쪽 아래 크롭 아이콘 (dummy)
                Positioned(
                  left: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(
                      Icons.open_in_full,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),

                // 오른쪽 아래 SELECT MULTIPLE (아이콘 + 텍스트)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.filter_none, // 겹쳐진 네모 느낌
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'SELECT MULTIPLE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
                : Container(
              color: Colors.black12,
              child: const Center(child: Text('No images')),
            ),
          ),

          // ─── 썸네일 그리드 ───
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1,
              ),
              itemCount: _dummyDeviceImages.length,
              itemBuilder: (context, index) {
                final path = _dummyDeviceImages[index];
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        path,
                        fit: BoxFit.cover,
                      ),
                      if (isSelected)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ─── 아래 탭 바 (GALLERY / PHOTO / VIDEO) ───
          const Divider(height: 1),
          SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _BottomTab(label: 'GALLERY', isActive: true),
                _BottomTab(label: 'PHOTO', isActive: false),
                _BottomTab(label: 'VIDEO', isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomTab extends StatelessWidget {
  final String label;
  final bool isActive;

  const _BottomTab({
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.black : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        // 밑줄 길고 조금 두껍게
        Container(
          height: 2,
          width: 80,
          color: isActive ? Colors.black : Colors.transparent,
        ),
      ],
    );
  }
}