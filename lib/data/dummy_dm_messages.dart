import 'package:instagram/models/dm_message.dart';

// 전체 메시지 flat 리스트
final List<DmMessage> dummyDmMessages = [

  // t1 혜빈
  DmMessage(
    messageId: 'm1',
    threadId: 't1',
    type: DmMessageType.text,
    text: 'so cute!!',
    createdAt: DateTime.now().subtract(Duration(seconds: 10)),
    isMine: false,
  ),
  DmMessage(
    messageId: 'm2',
    threadId: 't1',
    type: DmMessageType.text,
    text: 'Reply to haetbaaan…',
    createdAt: DateTime.now().subtract(Duration(seconds: 5)),
    isMine: true,
  ),
  DmMessage(
    messageId: 'm3',
    threadId: 't1',
    type: DmMessageType.image,
    text: null,
    mediaPath: "assets/images/album_covers/kitty_album.jpg",
    createdAt: DateTime.now().subtract(Duration(seconds: 5)),
    isMine: true,
  ),

  // t2 준혁
  DmMessage(
    messageId: 'm3',
    threadId: 't2',
    type: DmMessageType.text,
    text: 'Perfect!',
    createdAt: DateTime.now().subtract(Duration(days: 14)),
    isMine: false,
  ),
  DmMessage(
    messageId: 'm4',
    threadId: 't2',
    type: DmMessageType.text,
    text: 'Hi!!',
    createdAt: DateTime.now().subtract(Duration(days: 14, minutes: -3)),
    isMine: true,
  ),
];

// threadId → List<DmMessage> 변환
final Map<String, List<DmMessage>> dmMessagesByThreadId = (() {
  final map = <String, List<DmMessage>>{};
  for (final msg in dummyDmMessages) {
    map.putIfAbsent(msg.threadId, () => []);
    map[msg.threadId]!.add(msg);
  }
  return map;
})();