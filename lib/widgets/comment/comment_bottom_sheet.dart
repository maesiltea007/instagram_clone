import 'package:flutter/material.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/models/comment.dart';
import 'package:instagram/data/dummy_users.dart';
import 'package:instagram/data/dummy_comments.dart';

class CommentsBottomSheet extends StatefulWidget {
  final Post post;

  const CommentsBottomSheet({
    super.key,
    required this.post,
  });

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

// UI 전용 래퍼: 대댓글 여부 / 부모 id 저장
class _UiComment {
  final Comment comment;
  final bool isReply;
  final String? parentId;

  _UiComment({
    required this.comment,
    this.isReply = false,
    this.parentId,
  });
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  // 화면에 보여줄 댓글 리스트
  late List<_UiComment> _items;

  // 지금 어느 댓글에 대댓글 달려고 하는지
  Comment? _replyTarget;

  // 한 번이라도 대댓글을 단 부모 댓글 id -> "Reply to ..." 숨기기용
  final Set<String> _repliedParentIds = {};

  @override
  void initState() {
    super.initState();
    final baseList = commentsByPostId[widget.post.id] ?? <Comment>[];
    _items = baseList
        .map((c) => _UiComment(comment: c, isReply: false, parentId: null))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        // 키보드 높이만큼 아래 패딩
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildDragHandle(),
              const SizedBox(height: 8),
              _buildHeader(),
              const Divider(height: 1),

              Expanded(
                child: _items.isEmpty
                    ? _buildEmptyComments()
                    : _buildCommentsList(),
              ),

              // 이모지 위 divider
              Divider(height: 1, color: Colors.grey.shade300),

              _buildEmojiRow(),
              _buildInputRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Comments',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyComments() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Start the conversation.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    final postAuthor = usersById[widget.post.authorid];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final ui = _items[index];
        final c = ui.comment;
        final user = usersById[c.authorId];

        // 이 댓글이 게시물 작성자의 댓글인가?
        final bool isAuthorComment = c.authorId == widget.post.authorid;

        // "게시물 작성자가 이 댓글에 좋아요 눌렀는가?"
        final bool likedByPostAuthor = c.like && !isAuthorComment;

        final String timeText = _timeAgoShort(c.createdAt);

        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: ui.isReply ? 40 : 0, // 대댓글이면 왼쪽 여백
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(user?.profileImagePath ?? ''),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1줄: 아이디 + 시간 + (Author / 작성자 좋아요 배지)
                    Row(
                      children: [
                        Text(
                          user?.userNickName ?? 'unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeText,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),

                        // 이 댓글이 게시물 작성자의 댓글이면 "• Author"
                        if (isAuthorComment) ...[
                          const SizedBox(width: 4),
                          const Text(
                            '• Author',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],

                        // 작성자가 다른 사람의 댓글에 좋아요 눌렀을 때
                        if (likedByPostAuthor && postAuthor != null) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.favorite,
                            size: 12,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          CircleAvatar(
                            radius: 8,
                            backgroundImage:
                            AssetImage(postAuthor.profileImagePath),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 2),

                    // 2줄: 댓글 내용
                    Text(
                      c.text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // 3줄: Reply 영역
                    if (c.authorId == currentUser.id) ...[
                      // 내가 쓴 댓글
                      Row(
                        children: const [
                          Text(
                            'Reply',
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'See translation',
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ] else ...[
                      // 남이 쓴 댓글에 대해
                      Row(
                        children: const [
                          Text(
                            'Reply',
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Reply with a reel',
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Hide',
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 대댓글 아직 안 달았고, 이 댓글이 "부모"일 때만 표시
                      if (!ui.isReply &&
                          !_repliedParentIds.contains(c.id))
                        GestureDetector(
                          onTap: () {
                            // 입력창에 @닉네임 채우고 포커스
                            final nick = user?.userNickName ?? '';
                            setState(() {
                              _replyTarget = c;
                              _controller.text = '@$nick ';
                              _controller.selection =
                                  TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _controller.text.length,
                                    ),
                                  );
                            });
                            FocusScope.of(context)
                                .requestFocus(_inputFocusNode);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage:
                                AssetImage(currentUser.profileImagePath),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Reply to ${user?.userNickName ?? ''}…',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 오른쪽 좋아요 토글
              GestureDetector(
                onTap: () {
                  setState(() {
                    c.like = !c.like;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      c.like ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: c.like ? Colors.red : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 2),
                    if (c.like)
                      const Text(
                        '1',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmojiRow() {
    const emojis = ['❤️', '🙌', '🔥', '👏', '🥲', '😍', '😮', '😂'];

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final e in emojis)
            Text(
              e,
              style: const TextStyle(fontSize: 24),
            ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {},
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    final me = currentUser;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(me.profileImagePath),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _inputFocusNode,
              decoration: const InputDecoration(
                hintText: 'Add a comment...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            splashRadius: 20,
            onPressed: _handleSend,
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final newComment = Comment(
      id: 'local_${now.millisecondsSinceEpoch}',
      postid: widget.post.id,
      authorId: currentUser.id,
      text: text,
      createdAt: now,
    );

    final bool isReply = _replyTarget != null;
    final String? parentId = _replyTarget?.id;

    // 더미 데이터에도 저장
    final list = commentsByPostId[widget.post.id] ?? <Comment>[];
    list.add(newComment);
    commentsByPostId[widget.post.id] = list;

    setState(() {
      if (isReply && parentId != null) {
        // 1) 부모 index 찾기
        final parentIndex = _items.indexWhere((e) => e.comment.id == parentId);

        // 2) 이미 이 부모에 달린 대댓글들이 있는지 찾기
        int insertIndex = parentIndex + 1;

        while (
        insertIndex < _items.length &&
            _items[insertIndex].isReply &&
            _items[insertIndex].parentId == parentId
        ) {
          insertIndex++;
        }

        // 3) 그 위치에 삽입
        _items.insert(
          insertIndex,
          _UiComment(
            comment: newComment,
            isReply: true,
            parentId: parentId,
          ),
        );

        // Reply-to 표시 제거
        _repliedParentIds.add(parentId);
      } else {
        // 일반 댓글은 맨 마지막
        _items.add(
          _UiComment(
            comment: newComment,
            isReply: false,
            parentId: null,
          ),
        );
      }

      _replyTarget = null;
      _controller.clear();
    });
  }

  // ───────── 시간 표시 헬퍼 (s / m / h / d / w / y) ─────────
  String _timeAgoShort(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inSeconds < 60) {
      final s = diff.inSeconds;
      return '${s <= 0 ? 1 : s}s';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d';
    }
    if (diff.inDays < 30) {
      return '${diff.inDays ~/ 7}w';
    }
    if (diff.inDays < 365) {
      return '${diff.inDays ~/ 30}mo';
    }
    return '${diff.inDays ~/ 365}y';
  }
}