import 'package:flutter/material.dart';

class DmMediaPickerBottomSheet extends StatefulWidget {
  final void Function(String imagePath) onSelect;

  const DmMediaPickerBottomSheet({
    super.key,
    required this.onSelect,
  });

  @override
  State<DmMediaPickerBottomSheet> createState() =>
      _DmMediaPickerBottomSheetState();
}

class _DmMediaPickerBottomSheetState extends State<DmMediaPickerBottomSheet> {
  // 더미 갤러리 이미지
  final List<String> _dummyImages = const [
    'assets/dummy_device/images/puang_happy.jpg',
    'assets/dummy_device/images/video_preview.jpg',
  ];

  int? _selectedIndex; // 선택된 이미지 인덱스(없으면 null)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // 위 핸들
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),

            // 제목 줄 (Recents ▼)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: const [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Recents',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // 그리드 + (선택했을 때) 하단 프리뷰/전송 버튼
            Expanded(
              child: Column(
                children: [
                  // 그리드
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: _dummyImages.length,
                      itemBuilder: (context, index) {
                        final path = _dummyImages[index];
                        final bool selected = _selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex =
                              selected ? null : index; // 다시 누르면 해제
                            });
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    path,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (selected)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // 선택했을 때만 하단 preview + paper plane
                  if (_selectedIndex != null) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                      child: Row(
                        children: [
                          // 왼쪽 미니 프리뷰
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              _dummyImages[_selectedIndex!],
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Spacer(),
                          // 종이비행기 버튼
                          InkWell(
                            onTap: () {
                              final path = _dummyImages[_selectedIndex!];
                              // 여기서 실제 "보내기" 로직 연결하면 됨
                              widget.onSelect(path);
                              Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: const BoxDecoration(
                                color: Color(0xFF1877F2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}