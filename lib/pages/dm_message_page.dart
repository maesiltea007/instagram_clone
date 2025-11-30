import 'package:flutter/material.dart';
import 'package:instagram/models/dm_thread.dart';
import 'package:instagram/models/dm_message.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_dm_messages.dart';
import 'package:instagram/dm_bot/api_function.dart'; // ★ 봇 호출용

import '../data/dummy_dm_threads.dart';
import '../widgets/dm/dm_media_picker_bottom_sheet.dart';

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

  List<DmMessage> _messages = [];
  bool _hasText = false; // 입력 여부
  bool _isBotTyping = false; // ★ 봇 타이핑 상태

  @override
  void initState() {
    super.initState();
    _loadMessages();

    // 처음 열릴 때 맨 아래로 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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

  void _onTextChanged(String value) {
    final hasTextNow = value.trim().isNotEmpty;
    if (hasTextNow != _hasText) {
      setState(() {
        _hasText = hasTextNow;
      });
    }
  }

  // 텍스트 DM 보내기
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();

    final msg = DmMessage(
      messageId: 'local_${now.millisecondsSinceEpoch}',
      threadId: widget.thread.threadId,
      type: DmMessageType.text,
      text: text,
      mediaPath: null,
      createdAt: now,
      isMine: true,
    );

    setState(() {
      _messages.add(msg);

      final list =
          dmMessagesByThreadId[widget.thread.threadId] ?? <DmMessage>[];
      dmMessagesByThreadId[widget.thread.threadId] = [...list, msg];

      // thread 리스트도 갱신
      for (final t in dummyDmThreads) {
        if (t.threadId == widget.thread.threadId) {
          t.lastMessageText = text;
          t.lastMessageTime = now;
          t.isSeen = false;
        }
      }

      _controller.clear();
      _hasText = false;
    });

    _scrollToBottom();

    // ★ 봇 계정(10, 11)일 때만 답장
    if (widget.thread.peerUserId == '10' || widget.thread.peerUserId == '11') {
      _triggerBotReply(text);
    }
  }

  // 봇 답장 생성
  Future<void> _triggerBotReply(String userText) async {
    // 이미 dispose 됐으면 중단
    if (!mounted) return;

    setState(() {
      _isBotTyping = true;
    });
    _scrollToBottom();

    String botText;
    try {
      botText = await sendDMtoAI(userText);
      botText = botText.trim();
      if (botText.isEmpty) {
        botText = '...';
      }
    } catch (_) {
      // 실패해도 과제 시연용이니까 대충 한 줄 넣어줌
      botText = 'Got it 👍';
    }

    if (!mounted) return;

    final now = DateTime.now();

    final botMsg = DmMessage(
      messageId: 'bot_${now.millisecondsSinceEpoch}',
      threadId: widget.thread.threadId,
      type: DmMessageType.text,
      text: botText,
      mediaPath: null,
      createdAt: now,
      isMine: false,
    );

    setState(() {
      _isBotTyping = false;
      _messages.add(botMsg);

      final list =
          dmMessagesByThreadId[widget.thread.threadId] ?? <DmMessage>[];
      dmMessagesByThreadId[widget.thread.threadId] = [...list, botMsg];

      // thread 리스트 갱신
      for (final t in dummyDmThreads) {
        if (t.threadId == widget.thread.threadId) {
          t.lastMessageText = botText;
          t.lastMessageTime = now;
          t.isSeen = false;
        }
      }
    });

    _scrollToBottom();
  }

  // 이미지 DM 보내기 (봇 응답은 없음)
  void _sendImageMessage(String imagePath) {
    final now = DateTime.now();

    final msg = DmMessage(
      messageId: 'local_img_${now.millisecondsSinceEpoch}',
      threadId: widget.thread.threadId,
      type: DmMessageType.image,
      text: null,
      mediaPath: imagePath,
      createdAt: now,
      isMine: true,
    );

    setState(() {
      _messages.add(msg);

      final list =
          dmMessagesByThreadId[widget.thread.threadId] ?? <DmMessage>[];
      dmMessagesByThreadId[widget.thread.threadId] = [...list, msg];

      for (final t in dummyDmThreads) {
        if (t.threadId == widget.thread.threadId) {
          t.lastMessageText = '[Photo]';
          t.lastMessageTime = now;
          t.isSeen = false;
        }
      }
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
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
          // ───────── 메시지 리스트 ─────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                // ★ 마지막 아이템이 typing 버블인 경우
                if (_isBotTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                          child: const Text(
                            '...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final msg = _messages[index];
                final isMine = msg.isMine;

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
                              padding: EdgeInsets.symmetric(
                                horizontal: msg.type == DmMessageType.image
                                    ? 0
                                    : 12,
                                vertical: msg.type == DmMessageType.image
                                    ? 0
                                    : 8,
                              ),
                              decoration: BoxDecoration(
                                color: msg.type == DmMessageType.image
                                    ? Colors.transparent
                                    : (isMine
                                    ? const Color(0xFF8338FF)
                                    : const Color(0xFFF0F0F0)),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(18),
                                  topRight: const Radius.circular(18),
                                  bottomLeft:
                                  Radius.circular(isMine ? 18 : 4),
                                  bottomRight:
                                  Radius.circular(isMine ? 4 : 18),
                                ),
                              ),
                              child: _buildMessageContent(msg, isMine),
                            ),
                          ),
                          if (isMine) const SizedBox(width: 4),
                        ],
                      ),
                    ),
                    if (!isMine && index == _messages.length - 1 && !_isBotTyping)
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

          // ───────── 입력 바 ─────────
          _buildInputBar(),
        ],
      ),
    );
  }

  // 텍스트 / 이미지 메시지 내용 빌드
  Widget _buildMessageContent(DmMessage msg, bool isMine) {
    if (msg.type == DmMessageType.image && msg.mediaPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          msg.mediaPath!,
          width: 200,
          fit: BoxFit.cover,
        ),
      );
    }

    // 기본 텍스트
    return Text(
      msg.text ?? '',
      style: TextStyle(
        fontSize: 14,
        color: isMine ? Colors.white : Colors.black,
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
        child: Row(
          children: [
            // 왼쪽: 카메라 아이콘 영역 (항상 같은 폭)
            SizedBox(
              width: 34,
              height: 34,
              child: Opacity(
                opacity: _hasText ? 0 : 1,
                child: _buildCameraCircle(),
              ),
            ),

            const SizedBox(width: 8),

            // 가운데: 텍스트 입력 필드
            Expanded(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 4,
                  onChanged: _onTextChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    hintText: 'Message...',
                    border: InputBorder.none,
                    // 텍스트 있을 때만 돋보기 아이콘
                    prefixIcon: _hasText
                        ? const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    )
                        : null,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                      maxWidth: 32,
                      maxHeight: 32,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // 오른쪽: 툴 아이콘들 vs 종이비행기 (레이아웃 유지)
            SizedBox(
              height: 34,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 툴 아이콘 묶음
                  IgnorePointer(
                    ignoring: _hasText,
                    child: Opacity(
                      opacity: _hasText ? 0 : 1,
                      child: Row(
                        children: [
                          const Icon(Icons.mic_none, size: 22),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (sheetContext) =>
                                    DmMediaPickerBottomSheet(
                                      onSelect: (imagePath) {
                                        _sendImageMessage(imagePath);
                                      },
                                    ),
                              );
                            },
                            child: const Icon(Icons.image_outlined, size: 22),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.emoji_emotions_outlined, size: 22),
                          const SizedBox(width: 8),
                          const Icon(Icons.add, size: 22),
                        ],
                      ),
                    ),
                  ),

                  // 종이비행기 버튼
                  IgnorePointer(
                    ignoring: !_hasText,
                    child: Opacity(
                      opacity: _hasText ? 1 : 0,
                      child: InkWell(
                        onTap: _hasText ? _sendMessage : null,
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