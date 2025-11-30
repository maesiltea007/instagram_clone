import 'package:flutter/material.dart';
import 'package:instagram/models/dm_thread.dart';
import 'package:instagram/models/dm_message.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_dm_messages.dart'; // dmMessagesByThreadId 같은 맵 있다고 가정

class DmMessagePage extends StatefulWidget {
  final DmThread thread;

  const DmMessagePage({
    super.key,
    required this.thread,
  });

  @override
  State<DmMessagePage> createState() => _DmMessagePageState();
}

class _DmMessagePageState extends State<DmMessagePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool get _hasText => _controller.text.trim().isNotEmpty;

  List<DmMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    _messages = List<DmMessage>.from(
      dmMessagesByThreadId[widget.thread.threadId] ?? const <DmMessage>[],
    )..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = DmMessage(
      messageId: 'local_${DateTime.now().millisecondsSinceEpoch}',
      threadId: widget.thread.threadId,
      text: text,
      createdAt: DateTime.now(),
      isMine: true,
    );

    setState(() {
      _messages.add(msg);

      // 더미 스토어에도 반영 (원하면)
      final list =
          dmMessagesByThreadId[widget.thread.threadId] ?? <DmMessage>[];
      dmMessagesByThreadId[widget.thread.threadId] = [...list, msg];

      _controller.clear();
    });

    // 맨 아래로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final peer = usersById[widget.thread.peerUserId];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            if (peer != null)
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(peer.profileImagePath),
              ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  peer?.userName ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  peer?.userNickName ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: const [
          Icon(Icons.call_outlined),
          SizedBox(width: 16),
          Icon(Icons.videocam_outlined),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMine = msg.isMine;

                // 날짜 라벨 (이전 메시지랑 날짜가 바뀔 때만)
                final showDateLabel = index == 0 ||
                    !_isSameDay(
                      _messages[index - 1].createdAt,
                      msg.createdAt,
                    );

                return Column(
                  children: [
                    if (showDateLabel)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _fullTimeLabel(msg.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    Align(
                      alignment:
                      isMine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isMine)
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 6, bottom: 2),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                  peer?.profileImagePath ?? '',
                                ),
                              ),
                            ),
                          Flexible(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? const Color(0xFF8338FF) // 보라색 말풍선 느낌
                                    : const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft: Radius.circular(
                                      isMine ? 18 : 4), // 인스타 느낌 비슷하게
                                  bottomRight: Radius.circular(
                                      isMine ? 4 : 18),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isMine ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          if (isMine) const SizedBox(width: 4),
                        ],
                      ),
                    ),
                    // 맨 마지막 상대 메시지 아래 "Tap and hold to react" 흉내
                    if (!isMine && index == _messages.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tap and hold to react',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // 입력 영역
          _buildInputBar(),
        ],
      ),
    );
  }

  // 하단 입력 바
  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) {
            final hasText = value.text.trim().isNotEmpty;

            return Row(
              children: [
                // ───── 왼쪽 아이콘 부분 ─────
                if (!hasText)
                  _buildCameraCircle()                 // 카메라 동그라미
                else
                  const SizedBox(width: 34),           // 자리 맞추기용

                const SizedBox(width: 8),

                // ───── 가운데 텍스트 필드 ─────
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Message...',
                        border: InputBorder.none,
                        // 텍스트 있을 때만 돋보기 아이콘
                        prefixIcon: hasText
                            ? const Icon(
                          Icons.search,
                          size: 18,
                          color: Colors.grey,
                        )
                            : null,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ───── 오른쪽 아이콘/버튼 부분 ─────
                if (!hasText)
                  Row(
                    children: const [
                      Icon(Icons.mic_none, size: 22),
                      SizedBox(width: 8),
                      Icon(Icons.image_outlined, size: 22),
                      SizedBox(width: 8),
                      Icon(Icons.emoji_emotions_outlined, size: 22),
                      SizedBox(width: 8),
                      Icon(Icons.add, size: 22),
                    ],
                  )
                else
                // 종이비행기(전송) 버튼
                  InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF8338FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCameraCircle() {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF8338FF),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  // 오늘 / 날짜 라벨
  String _fullTimeLabel(DateTime t) {
    final now = DateTime.now();
    final isToday =
        t.year == now.year && t.month == now.month && t.day == now.day;

    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final ampm = t.hour < 12 ? 'AM' : 'PM';

    if (isToday) {
      return 'Today $hour:$minute $ampm';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final m = months[t.month - 1];
    return '$m ${t.day}, $hour:$minute $ampm';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}